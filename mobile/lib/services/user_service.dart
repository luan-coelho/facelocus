import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';

class UserService {
  final DioFetchApi _fetchApi = DioFetchApi();

  getAllByEventId(int eventId) async {
    String url = '${AppRoutes.user}?event=$eventId';
    final response = await _fetchApi.get(url);
    List<dynamic> data = response.data;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  getAllByNameOrCpf(String identifier) async {
    String url = '${AppRoutes.userSearch}?identifier=$identifier';
    final response = await _fetchApi.get(url);
    List<dynamic> data = response.data;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  getById(int id) async {
    final response = await _fetchApi.get('${AppRoutes.user}/$id');
    var data = response.data;
    return UserModel.fromJson(data);
  }
}
