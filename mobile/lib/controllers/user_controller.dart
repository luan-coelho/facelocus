import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/controllers/auth/session_controller.dart';
import 'package:facelocus/dtos/change_password_dto.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../shared/toast.dart';

class UserController extends GetxController {
  final UserService service;
  final Rx<UserModel?> _user = (null).obs;
  List<UserModel> _usersSearch = <UserModel>[].obs;
  List<UserModel> _users = <UserModel>[].obs;
  final Rxn<String> _userImagePath = Rxn<String>();
  final RxBool _isLoading = false.obs;

  Rx<UserModel?> get user => _user;

  List<UserModel> get users => _users;

  List<UserModel> get usersSearch => _usersSearch;

  Rxn<String> get userImagePath => _userImagePath;

  RxBool get isLoading => _isLoading;

  UserController({required this.service});

  fetchAllByEventId(int eventId) async {
    _isLoading.value = true;
    _users = await service.getAllByEventId(eventId);
    _isLoading.value = false;
  }

  fetchAllByNameOrCpf(String identifier) async {
    _isLoading.value = true;
    SessionController authController = Get.find<SessionController>();
    UserModel user = authController.authenticatedUser.value!;
    _usersSearch = await service.getAllByNameOrCpf(user.id!, identifier);
    _isLoading.value = false;
  }

  facePhotoProfileUploud(BuildContext context, File file) async {
    _isLoading.value = true;
    try {
      SessionController authController = Get.find<SessionController>();
      UserModel user = authController.authenticatedUser.value!;
      await service.facePhotoProfileUploud(file, user.id!);
      if (context.mounted) {
        context.replace(AppRoutes.home);
        Toast.showSuccess('Uploud realizado com sucesso', context);
      }
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        Toast.showError(detail, context);
      }
    }
    _isLoading.value = false;
  }

  changeFacePhoto(BuildContext context, File file) async {
    _isLoading.value = true;
    try {
      SessionController authController = Get.find<SessionController>();
      UserModel user = authController.authenticatedUser.value!;
      await service.facePhotoProfileUploud(file, user.id!);
      fetchFacePhotoById(context);
      if (context.mounted) {
        context.replace(AppRoutes.home);
        Toast.showSuccess('Foto alterada com sucesso', context);
      }
    } on DioException catch (e) {
      String detail = onError(e);
      if (context.mounted) {
        Toast.showError(detail, context);
      }
    }
    _isLoading.value = false;
  }

  checkFace(BuildContext context, File file) async {
    _isLoading.value = true;
    try {
      SessionController authController = Get.find<SessionController>();
      UserModel user = authController.authenticatedUser.value!;
      await service.checkFace(file, user.id!);
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

  changePassword(BuildContext context, ChangePasswordDTO credentials) async {
    _isLoading.value = true;
    try {
      SessionController authController = Get.find<SessionController>();
      UserModel user = authController.authenticatedUser.value!;
      await service.changePassword(user.id!, credentials);
      if (context.mounted) {
        context.pop();
        Toast.showSuccess('Senha alterada com sucesso', context);
      }
    } on DioException catch (e) {
      String detail = 'Não foi possível realizar o login';
      if (e.response?.data['detail'] != null) {
        detail = e.response?.data['detail'];
      }

      if (context.mounted) {
        Toast.showError(detail, context);
      }
    }
    _isLoading.value = false;
  }

  fetchFacePhotoById(BuildContext context) async {
    _isLoading.value = true;
    try {
      SessionController authController = Get.find<SessionController>();
      UserModel user = authController.authenticatedUser.value!;
      var response = await service.getFacePhotoById(user.id!);

      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/${user.id}.jpg';
      await clearImage();
      File file = File(filePath);
      await file.writeAsBytes(response.data!);
      userImagePath.value = filePath;
    } on DioException catch (e) {
      String detail = 'Não foi possível buscar a imagem de perfil';
      if (e.response?.data['detail'] != null) {
        detail = e.response?.data['detail'];
      }

      if (context.mounted) {
        Toast.showError(detail, context);
      }
    }
    _isLoading.value = false;
  }

  clearImage() async {
    if (_userImagePath.value != null) {
      await File(_userImagePath.value!).delete();
    }
    _userImagePath.value = null;
  }
}
