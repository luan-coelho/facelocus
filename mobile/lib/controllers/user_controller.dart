import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/services/user_service.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class UserController extends GetxController {
  final UserService service;
  final Rx<UserModel?> _user = (null).obs;
  List<UserModel> _usersSearch = <UserModel>[].obs;
  List<UserModel> _users = <UserModel>[].obs;

  Rx<UserModel?> get user => _user;

  List<UserModel> get users => _users;

  List<UserModel> get usersSearch => _usersSearch;

  final RxBool _isLoading = false.obs;

  RxBool get isLoading => _isLoading;

  UserController({required this.service});

  fetchAllByEventId(int eventId) async {
    _isLoading.value = true;
    _users = await service.getAllByEventId(eventId);
    _isLoading.value = false;
  }

  fetchAllByNameOrCpf(String identifier) async {
    _isLoading.value = true;
    _usersSearch = await service.getAllByNameOrCpf(identifier);
    _isLoading.value = false;
  }

  facePhotoProfileUploud(BuildContext context, File file) async {
    _isLoading.value = true;
    try {
      AuthController authController = Get.find<AuthController>();
      UserModel user = authController.authenticatedUser.value!;
      await service.facePhotoProfileUploud(file, user.id!);
      if (context.mounted) {
        context.replace(AppRoutes.home);
        MessageSnacks.success(context, 'Uploud realizado com sucesso');
      }
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        MessageSnacks.danger(context, detail);
      }
    }
    _isLoading.value = false;
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
}
