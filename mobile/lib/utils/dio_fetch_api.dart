import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/utils/fetch_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class DioFetchApi implements FetchApi {
  final Dio _dio = Dio();
  final String _baseUrl = AppConfigConst.baseApiUrl;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Future<Response> get(String url, {bool authHeaders = true}) async {
    final String? token = await getToken();
    var request = _dio.get('$_baseUrl$url',
        options: authHeaders ? _getAuthenticationHeaders(token) : null);
    _checkAuthorization(request);
    return await request;
  }

  @override
  Future<Response> post(String url,
      {Object? data, bool authHeaders = true}) async {
    final String? token = await getToken();
    var request = _dio.post('$_baseUrl$url',
        data: data,
        options: authHeaders ? _getAuthenticationHeaders(token) : null);
    _checkAuthorization(request);
    return await request;
  }

  @override
  Future<Response> patch(String url,
      {Object? data, bool authHeaders = true}) async {
    final String? token = await getToken();
    var request = _dio.patch('$_baseUrl$url',
        data: data,
        options: authHeaders ? _getAuthenticationHeaders(token) : null);
    _checkAuthorization(request);
    return await request;
  }

  @override
  Future<Response> delete(String url, {bool authHeaders = true}) async {
    final String? token = await getToken();
    var request = _dio.delete('$_baseUrl$url',
        options: authHeaders ? _getAuthenticationHeaders(token) : null);
    _checkAuthorization(request);
    return await request;
  }

  Options _getAuthenticationHeaders(String? token) {
    return Options(headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });
  }

  Future<Response> _checkAuthorization(Future<Response> fn) async {
    var response = await fn;
    final String? token = await getToken();
    if (token == null || response.statusCode == 401) {
      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        context.go(AppRoutes.login);
      }
    }
    return response;
  }

  Future<String?> getToken() async => await storage.read(key: 'token');
}
