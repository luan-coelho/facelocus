import 'package:dio/dio.dart';
import 'package:facelocus/dtos/login_request_dto.dart';
import 'package:facelocus/dtos/token_response_dto.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/services/auth_service.dart';
import 'package:facelocus/services/user_service.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final AuthService service;
  late final UserService _userService;
  late final FlutterSecureStorage _storage;
  late final SharedPreferences _prefs;

  final Rxn<UserModel?> _authenticatedUser = Rxn<UserModel>();

  Rx<UserModel?> get authenticatedUser => _authenticatedUser;

  AuthController({required this.service}) {
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
        await _prefs.setInt('user', userId);
        addAuthenticatedUser(tokenResponse.user);
        context.replace(AppRoutes.home);
        return;
      }
    } on DioException catch (e) {
      var detail = e.response?.data['detail'];
      String message = 'Não foi possível realizar o login';
      MessageSnacks.danger(context, detail ?? message);
    }
  }

  checkToken(BuildContext context) async {
    try {
      final int? userId = _prefs.getInt('user');
      if (userId == null) {
        removeToken();
        context.pushReplacement(AppRoutes.login);
        return;
      }
      var user = await _userService.getById(userId);
      addAuthenticatedUser(user);
      context.pushReplacement(AppRoutes.home);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        context.push(AppRoutes.login);
        MessageSnacks.warn(context, 'Sua sessão expirou');
      }
      var detail = e.response?.data['detail'];
      String message = 'Não foi possível realizar o login';
      MessageSnacks.danger(context, detail ?? message);
    }
  }

  prefsGetInstace() async {
    _prefs = await SharedPreferences.getInstance();
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
    await _prefs.remove('user');
    _authenticatedUser.value = null;
  }
}
