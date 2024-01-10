import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class Fetch<T> {
  static final Dio _dio = Dio();
  static const String _baseUrl = AppConfigConst.baseApiUrl;

  static dynamic call(BuildContext context, Future<Response> fun) async {
    final response = await fun;
    if (response.statusCode == 401) {
      context.pushReplacement(AppRoutes.login);
    }

   /* final response = _dio.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });*/
  }
}
