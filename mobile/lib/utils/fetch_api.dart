import 'package:dio/dio.dart';

abstract interface class FetchApi {
  Future<Response> get(String url, {bool authHeaders = true});

  Future<Response> post(String url,
      {Object? data, bool requireAuthentication = true});

  Future<Response> patch(String url, {Object? data, bool authHeaders = true});

  Future<Response> delete(String url, {bool authHeaders = true});
}
