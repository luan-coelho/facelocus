import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/models/event.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EventService {
  final Dio _dio = Dio();
  final String _baseUrl = AppConfigConst.baseApiUrl;

  Future<List<EventModel>> getAll() async {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    final response = await _dio.get('$_baseUrl${AppRoutes.event}',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        }));
    List data = response.data['data'];
    return data.map((json) => EventModel.fromJson(json)).toList();
  }

  Future<void> create(EventModel event) async {
    var json = event.toJson();
    await _dio.post('$_baseUrl${AppRoutes.event}', data: json);
  }

  Future<EventModel> getById(int id) async {
    final response = await _dio.get('$_baseUrl/event/$id');
    var data = response.data;
    return EventModel.fromJson(data);
  }

  Future<bool> changeTicketRequestPermission(int id) async {
    String url =
        "$_baseUrl${AppRoutes.event}/change-ticket-request-permission/$id";
    var response = await _dio.patch(url);
    return response.statusCode == 204;
  }

  Future<bool> generateNewCode(int id) async {
    String url = "$_baseUrl${AppRoutes.event}/generate-new-code/$id";
    var response = await _dio.patch(url);
    return response.statusCode == 204;
  }
}
