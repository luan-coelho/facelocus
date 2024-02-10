import 'package:dio/dio.dart';
import 'package:facelocus/controllers/auth/session_controller.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:facelocus/utils/expansion_panel_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../models/event_model.dart';
import '../shared/toast.dart';

class PointRecordController extends GetxController {
  final PointRecordService service;
  final Rxn<EventModel> event = Rxn<EventModel>();
  final Rxn<DateTime> _date = Rxn<DateTime>();
  final Rxn<PointRecordModel> _pointRecord = Rxn<PointRecordModel>();
  final List<PointRecordModel> _pointsRecord = <PointRecordModel>[].obs;
  final List<PointRecordModel> _pointsRecordByDate = <PointRecordModel>[].obs;
  List<PointModel> _points = <PointModel>[].obs;
  final Rx<DateTime> _firstDayCalendar = DateTime.now().obs;
  final Rx<DateTime> _lastDayCalendar = DateTime.now().obs;
  List<Item<UserModel>> _panelItems = <Item<UserModel>>[].obs;
  final Rx<DateTime> _initialDate = DateTime.now().obs;
  final Rx<DateTime> _finalDate = DateTime.now().obs;

  final RxBool _isLoading = false.obs;

  Rxn<DateTime> get date => _date;

  Rxn<PointRecordModel> get pointRecord => _pointRecord;

  List<PointRecordModel> get pointsRecord => _pointsRecord;

  List<PointRecordModel> get pointsRecordByDate => _pointsRecordByDate;

  List<PointModel> get points => _points;

  Rx<DateTime> get firstDay => _firstDayCalendar;

  Rx<DateTime> get lastDay => _lastDayCalendar;

  List<Item<UserModel>> get panelItems => _panelItems;

  Rx<DateTime> get initialDate => _initialDate;

  Rx<DateTime> get finalDate => _finalDate;

  RxBool get isLoading => _isLoading;

  PointRecordController({required this.service});

  cleanPointsList() {
    _points = <PointModel>[].obs;
    cleanPoint();
  }

  cleanPoint() {
    initialDate.value = DateTime.now();
    finalDate.value = DateTime.now();
  }

  String onError(DioException e, {String? message}) {
    if (e.response?.data != null && e.response?.data['detail'] != null) {
      return e.response?.data['detail'];
    }
    return message ?? 'Falha ao executar esta ação';
  }

  create(BuildContext context, PointRecordModel pointRecord) async {
    _isLoading.value = true;
    try {
      await service.create(pointRecord);
      if (context.mounted) {
        Toast.showSuccess('Registro de ponto criado com sucesso', context);
        event.value = null;
        context.pushReplacement(AppRoutes.home);
      }
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        Toast.showError(detail, context);
      }
    }
    if (context.mounted) {
      fetchAllByUser(context);
      fetchAllByDate(context, DateTime.now());
    }
  }

  fetchAllByDate(BuildContext context, DateTime date) async {
    _isLoading.value = true;
    SessionController authController = Get.find<SessionController>();
    UserModel administrator = authController.authenticatedUser.value!;
    List<PointRecordModel> pointsRecord;
    pointsRecord = await service.getAllByDate(administrator.id!, date);
    _pointsRecordByDate.clear();
    _pointsRecordByDate.addAll(pointsRecord);
    _isLoading.value = false;
  }

  fetchAllByUser(BuildContext context) async {
    _isLoading.value = true;
    SessionController authController = Get.find<SessionController>();
    UserModel administrator = authController.authenticatedUser.value!;
    List<PointRecordModel> pointsRecord;
    pointsRecord = await service.getAllByUser(administrator.id!);
    _pointsRecord.clear();
    _pointsRecord.addAll(pointsRecord);
    if (pointsRecord.isNotEmpty) {
      changeFirstAndLastDay(pointsRecord);
    }
    _isLoading.value = false;
  }

  changeFirstAndLastDay(List<PointRecordModel> pointsRecord) {
    // _firstDayCalendar.value = pointsRecord.first.date;
    // _lastDayCalendar.value = pointsRecord.last.date;
    DateTime firstDay = pointsRecord.first.date;
    DateTime today = DateTime.now();
    if (firstDay.isAfter(today)) {
      firstDay = today;
    }
    _firstDayCalendar.value = firstDay;
    _lastDayCalendar.value = pointsRecord.last.date;
  }

  fetchById(BuildContext context, int pointRecordId) async {
    _isLoading.value = true;
    _pointRecord.value = await service.getById(pointRecordId);
    _panelItems =
        Item<UserModel>().generateItems(pointRecord.value!.event!.users!);
    _isLoading.value = false;
  }
}
