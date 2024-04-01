import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/controllers/point_record_show_controller.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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
      var _prController = Get.find<PointRecordShowController>();
      await _prController.fetchById(context, pointRecordId);
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

  Future<String> getDeviceIdentifier() async {
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor ??
          'IOS - N/A'; // unique ID on iOS
    } else if (Platform.isAndroid) {
      const androidIdPlugin = AndroidId();
      return await androidIdPlugin.getId() ?? 'IOS - N/A';
    }
    return 'N/A';
  }

  void validateIndoorLocation() async {
    String identifier = await getDeviceIdentifier();
    print(identifier);
  }

  void activeBluetooh() async {
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }

    var subscription = FlutterBluePlus.adapterState.listen((
      BluetoothAdapterState state,
    ) {
      print(state);
      if (state == BluetoothAdapterState.on) {
        // usually start scanning, connecting, etc
      } else {
        // show an error to the user, etc
      }
    });
  }

  void startScanForDevicesWithUUID(String serviceUUID) {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.advertisementData.serviceUuids.contains(serviceUUID)) {
          print(
            "Dispositivo com serviço UUID $serviceUUID encontrado: ${result.device.platformName}",
          );
          FlutterBluePlus.stopScan();
        }
      }
    });
  }
}
