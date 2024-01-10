import 'package:dio/dio.dart';
import 'package:facelocus/dtos/token_response_dto.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final Dio _dio = Dio();
  final String _baseUrl = AppConfigConst.baseApiUrl;

  Future<TokenResponse> login(
      BuildContext context, String login, String password) async {
    String url = '$_baseUrl${AppRoutes.login}';
    var json = {'login': login, 'password': password};
    var response = await _dio.post(url, data: json);
    return TokenResponse.fromJson(response.data);
  }
}
