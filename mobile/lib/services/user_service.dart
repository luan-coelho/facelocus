import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';

class UserService {
  final DioFetchApi _fetchApi = DioFetchApi();

  Future<List<UserModel>> getAllByEventId(int eventId) async {
    String url = '${AppRoutes.user}?event=$eventId';
    final response = await _fetchApi.get(url);
    List<dynamic> data = response.data;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<List<UserModel>> getAllByNameOrCpf(String identifier) async {
    String url = '${AppRoutes.userSearch}?identifier=$identifier';
    final response = await _fetchApi.get(url);
    List<dynamic> data = response.data;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }
}
