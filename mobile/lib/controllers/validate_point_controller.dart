import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/controllers/location_controller.dart';
import 'package:facelocus/controllers/point_record_show_controller.dart';
import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/services/point_record_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../shared/toast.dart';

class ValidatePointController extends GetxController {
  final PointRecordRepository service;
  final RxBool _isLoading = false.obs;
  final RxBool _buttonLoading = false.obs;

  RxBool get isLoading => _isLoading;

  RxBool get buttonLoading => _buttonLoading;

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
      var _prController = Get.find<PointRecordShowController>();
      await _prController.fetchUserAttendanceById(context, pointRecordId);
      context.pop();
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

  Future<void> validateLocation(BuildContext context) async {
    _buttonLoading.value = true;
    var prController = Get.find<PointRecordShowController>();
    var locationController = Get.find<LocationController>();
    Position position = await locationController.determinePosition(context);
    LocationModel currentLocation = LocationModel(
      description: '',
      latitude: position.latitude,
      longitude: position.longitude,
    );
    var distance = locationController.calculateDistance(
      prController.userAttendance.value!.location,
      currentLocation,
    );
    if (distance < 15) {
      context.pop();
      Toast.showSuccess('Localização validada com sucesso', context);
    } else {
      Toast.showError('Localização inválida', context);
    }
    _buttonLoading.value = false;
  }
}
