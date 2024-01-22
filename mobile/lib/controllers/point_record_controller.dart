import 'package:dio/dio.dart';
import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PointRecordController extends GetxController {
  final PointRecordService service;
  final Rxn<DateTime> _date = Rxn<DateTime>();
  final List<PointRecordModel> _pointsRecord = <PointRecordModel>[].obs;
  final List<PointRecordModel> _pointsRecordByDate = <PointRecordModel>[].obs;
  List<PointModel> _points = <PointModel>[].obs;
  final Rx<DateTime> _firstDayCalendar = DateTime.now().obs;
  final Rx<DateTime> _lastDayCalendar = DateTime.now().obs;
  final RxBool _isLoading = false.obs;

  Rxn<DateTime> get date => _date;

  List<PointRecordModel> get pointsRecord => _pointsRecord;

  List<PointRecordModel> get pointsRecordByDate => _pointsRecordByDate;

  List<PointModel> get points => _points;

  Rx<DateTime> get firstDay => _firstDayCalendar;

  Rx<DateTime> get lastDay => _lastDayCalendar;

  RxBool get isLoading => _isLoading;

  PointRecordController({required this.service});

  cleanPoints() {
    _points = <PointModel>[].obs;
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
        MessageSnacks.success(context, 'Registro de ponto criado com sucesso');
      }
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        MessageSnacks.danger(context, detail);
      }
    }
    if (context.mounted) {
      fetchAllByUser(context);
    }
  }

  fetchAllByDate(BuildContext context, DateTime date) async {
    _isLoading.value = true;
    AuthController authController = Get.find<AuthController>();
    UserModel administrator = authController.authenticatedUser.value!;
    List<PointRecordModel> pointsRecord;
    pointsRecord = await service.getAllByDate(administrator.id!, date);
    _pointsRecordByDate.clear();
    _pointsRecordByDate.addAll(pointsRecord);
    _isLoading.value = false;
  }

  fetchAllByUser(BuildContext context) async {
    _isLoading.value = true;
    AuthController authController = Get.find<AuthController>();
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
    _firstDayCalendar.value = pointsRecord.first.date;
    _lastDayCalendar.value = pointsRecord.last.date;
  }
}
