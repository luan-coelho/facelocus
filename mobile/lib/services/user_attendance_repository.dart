import 'package:facelocus/models/user_attendace_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';

class UserAttendanceRepository {
  final DioFetchApi _fetchApi = DioFetchApi();

  Future<UserAttendanceModel> getByPointRecordAndUser(
    int pointRecordId,
    int userId,
  ) async {
    String url =
        '${AppRoutes.userAttendance}?pointrecord=$pointRecordId&user=$userId';
    final response = await _fetchApi.get(url);
    var json = response.data ?? [];
    return UserAttendanceModel.fromJson(json);
  }

  Future<List<UserAttendanceModel>> getAllByPointRecord(
    int pointRecordId,
  ) async {
    String url =
        '${AppRoutes.userAttendance}/by-point-record?pointrecord=$pointRecordId';
    final response = await _fetchApi.get(url);
    List data = response.data;
    return data.map((json) => UserAttendanceModel.fromJson(json)).toList();
  }
}
