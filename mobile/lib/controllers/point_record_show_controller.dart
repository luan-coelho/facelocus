import 'package:facelocus/controllers/auth/session_controller.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/models/user_attendace_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:facelocus/services/user_attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointRecordShowController extends GetxController {
  final UserAttendanceService service;
  final Rxn<PointRecordModel> _pointRecord = Rxn<PointRecordModel>();
  final Rxn<UserAttendanceModel> _userAttendance = Rxn<UserAttendanceModel>();
  final List<UserAttendanceModel> _uas = <UserAttendanceModel>[].obs;
  final RxBool _isLoading = false.obs;

  RxBool get isLoading => _isLoading;

  Rxn<UserAttendanceModel> get userAttendance => _userAttendance;

  Rxn<PointRecordModel> get pointRecord => _pointRecord;

  List<UserAttendanceModel> get uas => _uas;

  PointRecordShowController({required this.service});

  fetchById(BuildContext context, int pointRecordId) async {
    _isLoading.value = true;
    SessionController authController = Get.find<SessionController>();
    UserModel administrator = authController.authenticatedUser.value!;
    _userAttendance.value = await service.getByPointRecordAndUser(
      pointRecordId,
      administrator.id!,
    );
    _isLoading.value = false;
  }

  fetchAllByPointRecord(BuildContext context, int pointRecordId) async {
    _isLoading.value = true;
    var uas = await service.getAllByPointRecord(pointRecordId);
    _uas.clear();
    _uas.addAll(uas);
    _isLoading.value = false;
  }

  fetchPointRecordById(BuildContext context, int pointRecordId) async {
    _isLoading.value = true;
    PointRecordService pointRecordService = PointRecordService();
    _pointRecord.value = await pointRecordService.getById(pointRecordId);
    _isLoading.value = false;
  }
}
