import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';
import 'package:intl/intl.dart';

class PointRecordService {
  final DioFetchApi _fetchApi = DioFetchApi();

  getAllByUser(int userId) async {
    String url = '${AppRoutes.pointRecord}?user=$userId';
    final response = await _fetchApi.get(url);
    List<dynamic> data = response.data ?? [];
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

  changeLocation(int pointRecordId, int locationId) async {
    var url =
        '${AppRoutes.pointRecord}/change-location/?pointrecord=$pointRecordId&location=$locationId';
    await _fetchApi.patch(url);
  }

  changeDate(int pointRecordId, DateTime newDate) async {
    String datef = DateFormat('yyyy-MM-dd').format(newDate);
    var url =
        '${AppRoutes.pointRecord}/change-date/?pointrecord=$pointRecordId&date=$datef';
    await _fetchApi.patch(url);
  }

  validateUserPoints(List<AttendanceRecordModel?> ar) async {
    var url = '${AppRoutes.pointRecord}/validate-user-points';
    var data = ar.map((e) => e!.toJson()).toList();
    await _fetchApi.post(url, data: data);
  }

  validateFacialRecognitionFactorForAttendanceRecord(
    File facePhoto,
    int attendanceRecordId,
  ) async {
    var filename = "facephoto.jpg";
    var file = await MultipartFile.fromFile(facePhoto.path, filename: filename);
    var formData = FormData.fromMap({"fileName": filename, "file": file});
    String endpoint = '/validate-frf?attendanceRecord=$attendanceRecordId';
    String url = '${AppRoutes.pointRecord}$endpoint';
    return await _fetchApi.post(url, data: formData);
  }
}
