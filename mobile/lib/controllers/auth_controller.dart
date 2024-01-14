import 'package:dio/dio.dart';
import 'package:facelocus/dtos/login_request_dto.dart';
import 'package:facelocus/dtos/token_response_dto.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/services/auth_service.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AuthController extends GetxController {
  final AuthService service;
  // final Rxn<UserModel> _authenticatedUser = Rxn<UserModel>();
  final Rx<UserModel?> _authenticatedUser = (null as UserModel?).obs;

  Rx<UserModel?> get authenticatedUser => _authenticatedUser;


  AuthController({required this.service});

  addAuthenticatedUser(UserModel user) {
    _authenticatedUser.value = user;
  }

  logout() {
    _authenticatedUser.value = null;
  }

  login(BuildContext context, LoginRequest loginRequest) async {
    try {
      String login = loginRequest.login;
      String password = loginRequest.password;
      TokenResponse tokenResponse = await service.login(login, password);
      if (tokenResponse.token.isNotEmpty) {
        const storage = FlutterSecureStorage();
        await storage.write(key: 'token', value: tokenResponse.token);
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
}
