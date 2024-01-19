import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/user_service.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PointRecordController extends GetxController {
  final UserService service;
  final Rx<UserModel?> _user = (null).obs;

  Rx<UserModel?> get user => _user;

  final RxBool _isLoading = false.obs;

  RxBool get isLoading => _isLoading;

  PointRecordController({required this.service});

  checkFace(BuildContext context, File file) async {
    _isLoading.value = true;
    try {
      AuthController authController = Get.find<AuthController>();
      UserModel user = authController.authenticatedUser.value!;
      await service.checkFace(file, user.id!);
      MessageSnacks.success(context, 'Validação realizada com sucesso');
    } on DioException catch (e) {
      String detail = onError(e);
      MessageSnacks.danger(context, detail);
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
