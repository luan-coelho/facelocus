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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user', userId);
        addAuthenticatedUser(tokenResponse.user);
        if (context.mounted) {
          context.replace(AppRoutes.home);
        }
        return;
      }
    } on DioException catch (e) {
      String detail = 'Não foi possível realizar o login';
      if (e.response?.data['detail']) {
        detail = e.response?.data['detail'];
      }
      if (context.mounted) {
        MessageSnacks.danger(context, detail);
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
          context.pushReplacement(AppRoutes.login);
        }
        return;
      }
      var user = await _userService.getById(userId);
      addAuthenticatedUser(user);
      if (context.mounted) {
        context.pushReplacement(AppRoutes.home);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 && context.mounted) {
        context.push(AppRoutes.login);
        MessageSnacks.warn(context, 'Sua sessão expirou');
      }
      var detail = e.response?.data['detail'];
      String message = 'Não foi possível realizar o login';
      if (context.mounted) {
        MessageSnacks.danger(context, detail ?? message);
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
  }
}
