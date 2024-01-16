import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/utils/fetch_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' as getx;
import 'package:go_router/go_router.dart';

class DioFetchApi implements FetchApi {
  final Dio _dio = Dio();
  final String _baseUrl = AppConfigConst.baseApiUrl;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Future<Response> get(String url, {bool authHeaders = true}) async {
    try {
      final String? token = await getToken();
      return await _dio.get('$_baseUrl$url',
          options: authHeaders ? _getAuthenticationHeaders(token) : null);
    } on DioException catch (e) {
      _checkAuthorization(e);
      rethrow;
    }
  }

  @override
  Future<Response> post(String url,
      {Object? data, bool authHeaders = true}) async {
    try {
      final String? token = await getToken();
      var response = await _dio.post('$_baseUrl$url',
          data: data,
          options: authHeaders ? _getAuthenticationHeaders(token) : null);
      return response;
    } on DioException catch (e) {
      _checkAuthorization(e);
      rethrow;
    }
  }

  @override
  Future<Response> patch(String url,
      {Object? data, bool authHeaders = true}) async {
    try {
      final String? token = await getToken();
      return await _dio.patch('$_baseUrl$url',
          data: data,
          options: authHeaders ? _getAuthenticationHeaders(token) : null);
    } on DioException catch (e) {
      _checkAuthorization(e);
      rethrow;
    }
  }

  @override
  Future<Response> delete(String url, {bool authHeaders = true}) async {
    try {
      final String? token = await getToken();
      return await _dio.delete('$_baseUrl$url',
          options: authHeaders ? _getAuthenticationHeaders(token) : null);
    } on DioException catch (e) {
      _checkAuthorization(e);
      rethrow;
    }
  }

  Options _getAuthenticationHeaders(String? token) {
    return Options(headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });
  }

  void _checkAuthorization(DioException e) async {
    final String? token = await getToken();
    if (token == null || e.response?.statusCode == 401) {
      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        AuthController controller = getx.Get.find<AuthController>();
        controller.logout();
        context.go(AppRoutes.login);
      }
    }
  }

  Future<String?> getToken() async => await storage.containsKey(key: 'token')
      ? await storage.read(key: 'token')
      : null;
}
