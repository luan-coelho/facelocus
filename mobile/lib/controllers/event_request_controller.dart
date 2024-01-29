import 'package:dio/dio.dart';
import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/dtos/create_ticket_request_dto.dart';
import 'package:facelocus/dtos/event_request_create_dto.dart';
import 'package:facelocus/dtos/user_with_id_only_dto.dart';
import 'package:facelocus/models/event_request_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/event_request_service.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EventRequestController extends GetxController {
  final EventRequestService service;
  EventRequestModel? _eventRequest;
  final List<EventRequestModel> _eventsRequest = <EventRequestModel>[].obs;
  final RxBool _isLoading = false.obs;

  String? error;

  Map<String, dynamic>? invalidFields;

  EventRequestModel get eventRequest => _eventRequest!;

  List<EventRequestModel>? get eventsRequest => _eventsRequest;

  RxBool get isLoading => _isLoading;

  EventRequestController({required this.service});

  fetchAll({int? eventId}) async {
    _isLoading.value = true;
    try {
      AuthController authController = Get.find<AuthController>();
      int userId = authController.authenticatedUser.value!.id!;
      var eventsRequest = await service.fetchAll(userId);
      _eventsRequest.clear();
      _eventsRequest.addAll(eventsRequest);
    } on DioException catch (e) {
      String detail = onError(e, message: 'Falha ao buscar solicitações');
      error = detail;
    }
    _isLoading.value = false;
  }

  fetchById(int userId) async {
    _isLoading.value = true;
    _eventRequest = await service.getById(userId);
    _isLoading.value = false;
  }

  createTicketRequest(BuildContext context, String code) async {
    _isLoading.value = true;
    try {
      AuthController authController = Get.find<AuthController>();
      UserModel user = authController.authenticatedUser.value!;
      EventWithCodeDTO event = EventWithCodeDTO(code: code);
      UserWithIdOnly requestOwner = UserWithIdOnly(id: user.id);
      var eventRequest =
          CreateInvitationDTO(event: event, requestOwner: requestOwner);
      await service.createTicketRequest(eventRequest);
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

  createInvitation(BuildContext context, int eventId, int userId) async {
    _isLoading.value = true;
    try {
      EventWithCodeDTO event = EventWithCodeDTO(id: eventId);
      UserWithIdOnly requestOwner = UserWithIdOnly(id: userId);
      var eventRequest =
          CreateInvitationDTO(event: event, requestOwner: requestOwner);
      await service.createInvitation(eventRequest);
      String message = 'Convite enviado com sucesso';
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

  approve(BuildContext context, int eventRequestId) async {
    _isLoading.value = true;
    try {
      AuthController authController = Get.find<AuthController>();
      UserModel user = authController.authenticatedUser.value!;
      await service.approve(eventRequestId, user.id!);
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        Toast.danger(context, detail);
      }
    }
    fetchAll();
  }

  reject(BuildContext context, int eventRequestId) async {
    _isLoading.value = true;
    try {
      AuthController authController = Get.find<AuthController>();
      UserModel user = authController.authenticatedUser.value!;
      await service.reject(eventRequestId, user.id!);
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
