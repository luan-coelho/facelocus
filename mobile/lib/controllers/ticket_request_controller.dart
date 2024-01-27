import 'package:dio/dio.dart';
import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/dtos/event_ticket_request_create.dart';
import 'package:facelocus/dtos/ticket_request_create.dart';
import 'package:facelocus/models/ticket_request_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/ticket_request_service.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class TicketRequestController extends GetxController {
  final TicketRequestService service;
  TicketRequestModel? _ticketRequest;
  final List<TicketRequestModel> _ticketsRequest = <TicketRequestModel>[].obs;
  final RxBool _isLoading = false.obs;

  String? error;

  Map<String, dynamic>? invalidFields;

  TicketRequestModel get ticketRequest => _ticketRequest!;

  List<TicketRequestModel>? get ticketsRequest => _ticketsRequest;

  RxBool get isLoading => _isLoading;

  TicketRequestController({required this.service});

  fetchAll({int? eventId}) async {
    _isLoading.value = true;

    try {
      AuthController authController = Get.find<AuthController>();
      int userId = authController.authenticatedUser.value!.id!;
      var ticketsRequest = await service.fetchAll(userId, eventId: eventId);
      _ticketsRequest.addAll(ticketsRequest);
    } on DioException catch (e) {
      String detail = onError(e, message: 'Falha ao buscar solicitações');
      error = detail;
    }
    _isLoading.value = false;
  }

  fetchById(int userId) async {
    _isLoading.value = true;
    _ticketRequest = await service.getById(userId);
    _isLoading.value = false;
  }

  createByCode(BuildContext context, String code) async {
    _isLoading.value = true;

    try {
      AuthController authController = Get.find<AuthController>();
      UserModel user = authController.authenticatedUser.value!;
      EventTicketRequestCreate event = EventTicketRequestCreate(user: user);
      event.code = code;
      TicketRequestCreate ticketRequest =
          TicketRequestCreate(event: event, user: user);
      await service.create(ticketRequest);
      String message = 'Solicitação de ingresso enviada com sucesso';
      if (context.mounted) {
        Toast.success(context, message);
        context.pop();
      }
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        Toast.danger(context, detail);
      }
    }
    fetchAll();
  }

  approve(BuildContext context, int ticketRequestId) async {
    _isLoading.value = true;

    try {
      AuthController authController = Get.find<AuthController>();
      UserModel user = authController.authenticatedUser.value!;
      await service.approve(ticketRequestId, user.id!);
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        Toast.danger(context, detail);
      }
    }
    fetchAll();
  }

  reject(BuildContext context, int ticketRequestId) async {
    _isLoading.value = true;

    try {
      AuthController authController = Get.find<AuthController>();
      UserModel user = authController.authenticatedUser.value!;
      await service.reject(ticketRequestId, user.id!);
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        Toast.danger(context, detail);
      }
    }
    fetchAll();
  }

  String onError(DioException e, {String? message}) {
    if (e.response?.data != null && e.response?.data['detail'] != null) {
      String detail = e.response?.data['detail'];
      if (e.response?.data['invalidFields'] != null) {
        invalidFields = e.response?.data['invalidFields'];
      }
      return detail;
    }
    return message ?? 'Falha ao executar esta ação';
  }
}
