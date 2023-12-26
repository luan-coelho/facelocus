import 'package:dio/dio.dart';
import 'package:facelocus/models/event.dart';

class EventService {
  final Dio _dio = Dio();
  final String _baseUrl = "http://10.0.2.2:8080";

  Future<List<Event>> getAll() async {
    try {
      final response = await _dio.get('$_baseUrl/event');
      List data = response.data['data'];
      return data.map((json) => Event.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar eventos: $e');
    }
  }

  Future<void> create(Event event) async {
    try {
      await _dio.post('$_baseUrl/event', data: event.toJson());
    } catch (e) {
      throw Exception('Erro ao criar encomenda: $e');
    }
  }
}
