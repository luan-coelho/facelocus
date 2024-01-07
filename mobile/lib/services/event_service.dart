import 'package:dio/dio.dart';
import 'package:facelocus/models/event.dart';
import 'package:facelocus/shared/constants.dart';

class EventService {
  final Dio _dio = Dio();
  final String _baseUrl = AppConfigConst.baseApiUrl;

  Future<List<Event>> getAll() async {
    final response = await _dio.get('$_baseUrl/event');
    List data = response.data['data'];
    return data.map((json) => Event.fromJson(json)).toList();
  }

  Future<void> create(Event event) async {
    var json = event.toJson();
    await _dio.post('$_baseUrl/event', data: json);
  }

  Future<Event> getById(int id) async {
    final response = await _dio.get('$_baseUrl/event/$id');
    var data = response.data;
    return Event.fromJson(data);
  }

  Future<bool> changeTicketRequestPermission(int id) async {
    String url = "$_baseUrl/event/change-ticket-request-permission/$id";
    var response = await _dio.patch(url);
    return response.statusCode == 204;
  }
}
