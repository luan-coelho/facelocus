import 'package:dio/dio.dart';

class ResponseApiMessage {
  static buildMessage(DioException e) {
    String detail = e.response?.data['detail'];
    if (e.response?.data['detail'] != null) {
      detail = e.response?.data['detail'];
    }
    return detail;
  }
}
