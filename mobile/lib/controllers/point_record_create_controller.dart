import 'dart:math' as math;

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
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../models/event_model.dart';
import '../shared/toast.dart';

class PointRecordCreateController extends GetxController {
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

  final List<NeatCleanCalendarEvent> _prEvents = <NeatCleanCalendarEvent>[].obs;

  final RxBool _isLoading = false.obs;

  final RxBool _isLoadingPr = false.obs;

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

  RxBool get isLoadingPr => _isLoadingPr;

  List<NeatCleanCalendarEvent> get prEvents => _prEvents;

  PointRecordCreateController({required this.service});

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
    }
  }

  fetchAllByUser(BuildContext context) async {
    _isLoading.value = true;
    SessionController authController = Get.find<SessionController>();
    UserModel administrator = authController.authenticatedUser.value!;
    List<PointRecordModel> pointsRecord;
    pointsRecord = await service.getAllByUser(administrator.id!);
    _prEvents.clear();
    if (pointsRecord.isNotEmpty) {
      await buildPointsRecordEvents(pointsRecord);
    }
    _isLoading.value = false;
  }

  fetchById(BuildContext context, int pointRecordId) async {
    _isLoading.value = true;
    _pointRecord.value = await service.getById(pointRecordId);
    _isLoading.value = false;
  }

  buildPointsRecordEvents(List<PointRecordModel> pointsRecord) async {
    List<NeatCleanCalendarEvent> eventList = [];
    for (var pr in pointsRecord) {
      DateTime startTime = pr.points.first.initialDate;
      DateTime finalTime = pr.points.last.finalDate;
      var prEvent = NeatCleanCalendarEvent(pr.event!.description!,
          description: pr.location!.description,
          startTime: startTime,
          endTime: finalTime,
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0),
          metadata: pr.toJson());
      eventList.add(prEvent);
    }
    _prEvents.addAll(eventList);
  }
}
