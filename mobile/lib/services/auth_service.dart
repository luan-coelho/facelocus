import 'package:facelocus/dtos/token_response_dto.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final DioFetchApi _fetchApi = DioFetchApi();

  Future<TokenResponse> login(
      BuildContext context, String login, String password) async {
    String url = AppRoutes.login;
    var json = {'login': login, 'password': password};
    var response = await _fetchApi.post(url, data: json, authHeaders: false);
    return TokenResponse.fromJson(response.data);
  }
}
