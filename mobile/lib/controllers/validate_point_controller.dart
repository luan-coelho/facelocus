import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/controllers/point_record_show_controller.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../shared/toast.dart';

class ValidatePointController extends GetxController {
  final PointRecordService service;
  final RxBool _isLoading = false.obs;

  RxBool get isLoading => _isLoading;

  ValidatePointController({required this.service});

  validateFacialRecognitionFactorForAttendanceRecord(
    BuildContext context,
    int attendanceRecordId,
    int pointRecordId,
    File file,
  ) async {
    _isLoading.value = true;
    try {
      await service.validateFacialRecognitionFactorForAttendanceRecord(
        file,
        attendanceRecordId,
      );
      if (context.mounted) {
        Toast.showSuccess('Validação realizada com sucesso', context);
      }
      PointRecordShowController _controller =
          Get.find<PointRecordShowController>();
      await _controller.fetchById(context, pointRecordId);
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        Toast.showError(detail, context);
      }
    }
    context.pop();
    _isLoading.value = false;
  }

  String onError(DioException e, {String? message}) {
    if (e.response?.data != null && e.response?.data['detail'] != null) {
      return e.response?.data['detail'];
    }
    return message ?? 'Falha ao executar esta ação';
  }
}
