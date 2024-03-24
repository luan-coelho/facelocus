import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../shared/toast.dart';

class ValidatePointController extends GetxController {
  final PointRecordService service;
  final RxBool _isLoading = false.obs;

  RxBool get isLoading => _isLoading;

  ValidatePointController({required this.service});

  validateFacialRecognitionFactorForAttendanceRecord(
    BuildContext context,
    int attendanceRecordId,
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
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        Toast.showError(detail, context);
      }
    }
    _isLoading.value = false;
  }

  String onError(DioException e, {String? message}) {
    if (e.response?.data != null && e.response?.data['detail'] != null) {
      return e.response?.data['detail'];
    }
    return message ?? 'Falha ao executar esta ação';
  }
}
