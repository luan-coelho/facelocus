import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/utils/fetch_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioFetchApi implements FetchApi {
  final Dio _dio = Dio();
  final String _baseUrl = AppConfigConst.baseApiUrl;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Future<Response> get(String url, {bool authHeaders = true}) async {
    final String? token = await storage.read(key: 'token');
    return await _dio.get('$_baseUrl$url',
        options: authHeaders ? _getAuthenticationHeaders(token) : null);
  }

  @override
  Future<Response> post(String url,
      {Object? data, bool authHeaders = true}) async {
    final String? token = await storage.read(key: 'token');
    return await _dio.post('$_baseUrl$url',
        data: data,
        options: authHeaders ? _getAuthenticationHeaders(token) : null);
  }

  @override
  Future<Response> patch(String url,
      {Object? data, bool authHeaders = true}) async {
    final String? token = await storage.read(key: 'token');
    return await _dio.patch('$_baseUrl$url',
        data: data,
        options: authHeaders ? _getAuthenticationHeaders(token) : null);
  }

  @override
  Future<Response> delete(String url, {bool authHeaders = true}) async {
    final String? token = await storage.read(key: 'token');
    return await _dio.delete('$_baseUrl$url',
        options: authHeaders ? _getAuthenticationHeaders(token) : null);
  }

  Options _getAuthenticationHeaders(String? token) {
    return Options(headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });
  }
}
