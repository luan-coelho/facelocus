import 'package:dio/dio.dart';
import 'package:facelocus/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:facelocus/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/auth_service.dart';
import 'package:facelocus/services/user_service.dart';
import 'package:facelocus/dtos/login_request_dto.dart';
import 'package:facelocus/dtos/token_response_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionController extends GetxController {
  final AuthService service;
  late final UserService _userService;
  late final FlutterSecureStorage _storage;

  final Rxn<UserModel?> _authenticatedUser = Rxn<UserModel>();

  Rx<UserModel?> get authenticatedUser => _authenticatedUser;

  SessionController({required this.service}) {
    _storage = const FlutterSecureStorage();
    _userService = UserService();
  }

  login(BuildContext context, LoginRequest loginRequest) async {
    try {
      String login = loginRequest.login;
      String password = loginRequest.password;
      TokenResponse tokenResponse = await service.login(login, password);
      if (tokenResponse.token.isNotEmpty) {
        String token = tokenResponse.token;
        int userId = tokenResponse.user.id!;
        await _storage.write(key: 'token', value: token);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user', userId);
        UserModel user = tokenResponse.user;
        addAuthenticatedUser(user);

        if (context.mounted) {
          if (user.facePhoto == null) {
            context.replace(AppRoutes.userUploadFacePhoto);
            return;
          }
          UserController userController = Get.find<UserController>();
          userController.fetchFacePhotoById(context);
          context.replace(AppRoutes.home);
        }

        return;
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
  }

  checkLogin(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user');
      if (userId == null) {
        removeToken();
        await prefs.remove('user');
        if (context.mounted) {
          context.replace(AppRoutes.login);
        }
        return;
      }
      var user = await _userService.getById(userId);
      addAuthenticatedUser(user);
      if (context.mounted) {
        if (user.facePhoto == null) {
          context.pushReplacement(AppRoutes.userUploadFacePhoto);
          return;
        }
        context.pushReplacement(AppRoutes.home);
        UserController userController = Get.find<UserController>();
        userController.fetchFacePhotoById(context);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 && context.mounted) {
        context.replace(AppRoutes.login);
        Toast.showAlert('Sua sessão expirou', context);
      }

      String message = 'Não foi possível realizar o login';
      if (e.response?.data['detail'] != null) {
        message = e.response?.data['detail'];
      }

      if (context.mounted) {
        Toast.showError(message, context);
      }
    }
  }

  isLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get('user') != null;
  }

  getToken() async {
    return await _storage.read(key: 'token');
  }

  removeToken() async {
    return _storage.delete(key: 'token');
  }

  addAuthenticatedUser(UserModel user) {
    _authenticatedUser.value = user;
  }

  logout() async {
    removeToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    _authenticatedUser.value = null;
    UserController userController = Get.find<UserController>();
    userController.clearImage();
  }
}
