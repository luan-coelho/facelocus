import 'package:dio/dio.dart';
import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/event_service.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EventController extends GetxController {
  final EventService service;

  final List<EventModel> _events = <EventModel>[].obs;
  EventModel? _event;

  Map<String, dynamic>? invalidFields;

  final RxBool _isLoading = false.obs;

  RxBool get isLoading => _isLoading;

  EventModel? get event => _event;

  List<EventModel> get events => _events;

  EventController({required this.service});

  fetchAll() async {
    _isLoading.value = true;
    AuthController authController = Get.find<AuthController>();
    UserModel administrator = authController.authenticatedUser.value!;
    List<EventModel> events = await service.getAllByUser(administrator.id!);
    _events.clear();
    _events.addAll(events);
    _isLoading.value = false;
  }

  fetchAllByDescription(BuildContext context, String description) async {
    _isLoading.value = true;
    AuthController authController = Get.find<AuthController>();
    UserModel administrator = authController.authenticatedUser.value!;
    List<EventModel> events;
    events = await service.getAllByDescription(administrator.id!, description);
    _events.clear();
    _events.addAll(events);
    _isLoading.value = false;
  }

  fetchById(int eventId) async {
    _isLoading.value = true;
    _event = await service.getById(eventId);
    _isLoading.value = false;
  }

  Future<void> create(BuildContext context, EventModel event) async {
    _isLoading.value = true;
    try {
      AuthController authController = Get.find<AuthController>();
      UserModel administrator = authController.authenticatedUser.value!;
      event.administrator = administrator;
      await service.create(event);
      if (context.mounted) {
        Toast.success(context, 'Evento criado com sucesso');
        context.pop();
      }
    } on DioException catch (e) {
      String detail = onError(e, message: 'Falha ao criar evento');
      if (context.mounted) {
        Toast.danger(context, detail);
      }
    }
    fetchAll();
  }

  Future<void> changeTicketRequestPermission(int eventId) async {
    await service.changeTicketRequestPermission(eventId);
    fetchById(eventId);
  }

  Future<void> generateNewCode(int eventId) async {
    await service.generateNewCode(eventId);
    fetchById(eventId);
  }

  String onError(DioException e, {String? message}) {
    if (e.response?.data == Map && e.response?.data['detail'] != null) {
      String detail = e.response?.data.containsKey('detail');
      if (e.response?.data['invalidFields'] != null) {
        invalidFields = e.response?.data['invalidFields'];
      }
      return detail;
    }
    return message ?? 'Falha ao executar esta ação';
  }
}
