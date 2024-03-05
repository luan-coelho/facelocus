import 'package:facelocus/models/user_attendace_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';

class UserAttendanceService {
  final DioFetchApi _fetchApi = DioFetchApi();

  getByPointRecordAndUser(int pointRecordId, int userId) async {
    String url =
        '${AppRoutes.userAttendance}?pointrecord=$pointRecordId&user=$userId';
    final response = await _fetchApi.get(url);
    var json = response.data ?? [];
    return UserAttendanceModel.fromJson(json);
  }
}
