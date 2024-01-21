import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';
import 'package:intl/intl.dart';

class PointRecordService {
  final DioFetchApi _fetchApi = DioFetchApi();

  getAllByUser(int userId) async {
    String url = '${AppRoutes.pointRecord}?user=$userId';
    final response = await _fetchApi.get(url);
    List data = response.data['data'];
    return data.map((json) => PointRecordModel.fromJson(json)).toList();
  }

  getAllByDate(int userId, DateTime date) async {
    String datef = DateFormat('yyyy-MM-dd').format(date);
    String url = '${AppRoutes.pointRecord}/by-date?user=$userId&date=$datef';
    final response = await _fetchApi.get(url);
    List<dynamic> data = response.data;
    return data.map((json) => PointRecordModel.fromJson(json)).toList();
  }

  create(PointRecordModel pointRecord) async {
    var json = pointRecord.toJson();
    await _fetchApi.post(AppRoutes.pointRecord, data: json);
  }

  getById(int id) async {
    final response = await _fetchApi.get('${AppRoutes.pointRecord}/$id');
    var data = response.data;
    return PointRecordModel.fromJson(data);
  }
}
