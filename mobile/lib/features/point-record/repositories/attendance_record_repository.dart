import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';

class AttendanceRecordRepository {
  final DioFetchApi _fetchApi = DioFetchApi();

  Future<AttendanceRecordModel> getById(int id) async {
    String url = "${AppRoutes.attendanceRecord}/$id";
    final response = await _fetchApi.get(url);
    var data = response.data;
    return AttendanceRecordModel.fromJson(data);
  }
}
