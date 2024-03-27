import 'package:dio/dio.dart';
import 'package:facelocus/controllers/auth/session_controller.dart';
import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/models/user_attendace_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:facelocus/services/user_attendance_service.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class PointRecordShowController extends GetxController {
  final UserAttendanceService service;
  final Rxn<PointRecordModel> _pointRecord = Rxn<PointRecordModel>();
  final Rxn<UserAttendanceModel> _userAttendance = Rxn<UserAttendanceModel>();
  final List<UserAttendanceModel> _uas = <UserAttendanceModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _prLoading = false.obs;

  RxBool get isLoading => _isLoading;

  RxBool get prIsLoading => _prLoading;

  Rxn<UserAttendanceModel> get userAttendance => _userAttendance;

  Rxn<PointRecordModel> get pointRecord => _pointRecord;

  List<UserAttendanceModel> get uas => _uas;

  PointRecordShowController({required this.service});

  fetchById(BuildContext context, int pointRecordId) async {
    _isLoading.value = true;
    try {
      SessionController authController = Get.find<SessionController>();
      UserModel administrator = authController.authenticatedUser.value!;
      _userAttendance.value = await service.getByPointRecordAndUser(
        pointRecordId,
        administrator.id!,
      );
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        context.pop();
        Toast.showError(detail, context);
      }
    }
    _isLoading.value = false;
  }

  fetchAllByPointRecord(
    BuildContext context,
    int pointRecordId, {
    bool loading = true,
  }) async {
    if (loading) _isLoading.value = true;
    var uas = await service.getAllByPointRecord(pointRecordId);
    _uas.clear();
    _uas.addAll(uas);
    if (loading) _isLoading.value = false;
  }

  fetchPointRecordById(
    BuildContext context,
    int pointRecordId, {
    bool loading = true,
  }) async {
    if (loading) _prLoading.value = true;
    PointRecordService pointRecordService = PointRecordService();
    _pointRecord.value = await pointRecordService.getById(pointRecordId);
    if (loading) _prLoading.value = false;
  }

  String onError(DioException e, {String? message}) {
    if (e.response?.data != null && e.response?.data['detail'] != null) {
      return e.response?.data['detail'];
    }
    return message ?? 'Falha ao executar esta ação';
  }

  validateUserPoints(
    BuildContext context,
    List<AttendanceRecordModel?> ars,
    int pointRecordId,
  ) async {
    _isLoading.value = true;
    try {
      PointRecordService pointRecordService = PointRecordService();
      _pointRecord.value = await pointRecordService.validateUserPoints(ars);
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        Toast.showError(detail, context);
      }
    }
    fetchPointRecordById(context, pointRecordId, loading: false);
    fetchAllByPointRecord(context, pointRecordId);
    _isLoading.value = false;
  }
}
