import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/models/location_validation_attempt.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';
import 'package:intl/intl.dart';

class PointRecordRepository {
  final DioFetchApi _fetchApi = DioFetchApi();

  Future<List<PointRecordModel>> getAllByUser(int userId) async {
    String url = '${AppRoutes.pointRecord}?user=$userId';
    final response = await _fetchApi.get(url);
    List<dynamic> data = response.data ?? [];
    return data.map((json) => PointRecordModel.fromJson(json)).toList();
  }

  Future<List<PointRecordModel>> getAllByDate(int userId, DateTime date) async {
    String datef = DateFormat('yyyy-MM-dd').format(date);
    String url = '${AppRoutes.pointRecord}/by-date?user=$userId&date=$datef';
    final response = await _fetchApi.get(url);
    List<dynamic> data = response.data;
    return data.map((json) => PointRecordModel.fromJson(json)).toList();
  }

  Future<PointRecordModel> create(PointRecordModel pointRecord) async {
    var json = pointRecord.toJson();
    var response = await _fetchApi.post(AppRoutes.pointRecord, data: json);
    return PointRecordModel.fromJson(response.data);
  }

  Future<PointRecordModel> getById(int id) async {
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

  Future<Response> validateLocationFactor(
    int attendanceRecordId,
    LocationValidationAttempt attempt,
  ) async {
    String endpoint = '/validate-lf?attendanceRecord=$attendanceRecordId';
    String url = '${AppRoutes.pointRecord}$endpoint';
    var data = attempt.toJson();
    return await _fetchApi.post(url, data: data);
  }

  Future<Response> validateFacialRecognitionFactor(
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

  Future<Response> deleteById(int id) async {
    return await _fetchApi.delete('${AppRoutes.pointRecord}/$id');
  }
}
