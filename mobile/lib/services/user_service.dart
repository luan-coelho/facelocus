import 'package:dio/dio.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';

class UserService {
  final Dio _dio = Dio();
  final String _baseUrl = AppConfigConst.baseApiUrl;

  Future<List<UserModel>> getAllByEventId(int eventId) async {
    String url = '$_baseUrl${AppRoutes.user}?event=$eventId';
    final response = await _dio.get(url);
    List<dynamic> data = response.data;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<List<UserModel>> getAllByNameOrCpf(String identifier) async {
    String url = '$_baseUrl${AppRoutes.userSearch}?identifier=$identifier';
    final response = await _dio.get(url);
    List<dynamic> data = response.data;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }
}
