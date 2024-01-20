import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:facelocus/services/user_service.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PointRecordController extends GetxController {
  final UserService service;
  final PointRecordService pointRecordService;
  final Rxn<DateTime> _date = Rxn<DateTime>();
  List<PointModel> _points = <PointModel>[].obs;
  final RxBool _isLoading = false.obs;

  Rxn<DateTime> get date => _date;

  List<PointModel> get points => _points;

  RxBool get isLoading => _isLoading;

  PointRecordController(
      {required this.service, required this.pointRecordService});

  cleanPoints() {
    _points = <PointModel>[].obs;
  }

  checkFace(BuildContext context, File file) async {
    _isLoading.value = true;
    try {
      AuthController authController = Get.find<AuthController>();
      UserModel user = authController.authenticatedUser.value!;
      await service.checkFace(file, user.id!);
      if (context.mounted) {
        MessageSnacks.success(context, 'Validação realizada com sucesso');
      }
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        MessageSnacks.danger(context, detail);
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

  create(BuildContext context, PointRecordModel pointRecord) async {
    _isLoading.value = true;
    try {
      await pointRecordService.create(pointRecord);
      if (context.mounted) {
        MessageSnacks.success(context, 'Registro de ponto criado com sucesso');
      }
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        MessageSnacks.danger(context, detail);
      }
    }
    _isLoading.value = false;
  }
}
