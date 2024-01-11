import 'package:facelocus/dtos/token_response_dto.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';

class AuthService {
  final DioFetchApi _fetchApi = DioFetchApi();

  Future<TokenResponse> login(String login, String password) async {
    String url = AppRoutes.login;
    var json = {'login': login, 'password': password};
    var response = await _fetchApi.post(url, data: json, authHeaders: false);
    return TokenResponse.fromJson(response.data);
  }

  Future<void> register(UserModel user) async {
    String url = AppRoutes.register;
    var json = user.toJson();
    await _fetchApi.post(url, data: json, authHeaders: false);
  }
}
