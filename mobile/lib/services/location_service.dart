import 'package:dio/dio.dart';
import 'package:facelocus/models/event.dart';
import 'package:facelocus/models/location.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/widgets.dart';

class LocationService {
  final Dio _dio = Dio();
  final String _baseUrl = "http://10.0.2.2:8080";

  Future<List<Location>> getAllByEventId(
      BuildContext context, int eventId) async {
    try {
      final response =
          await _dio.get('$_baseUrl/event-location?event=$eventId');
      List<dynamic> data = response.data;
      return data.map((json) => Location.fromJson(json)).toList();
    } catch (e) {
      MessageSnacks.danger(context, "Falha ao buscar localizações");
      throw Exception("Erro ao buscar localizações: $e");
    }
  }

  Future<void> create(
      BuildContext context, Location location, int eventId) async {
    try {
      var json = location.toJson();
      await _dio.post('$_baseUrl/event-location?event=$eventId', data: json);
      MessageSnacks.success(context, "Localização cadastrada com sucesso");
    } catch (e) {
      MessageSnacks.danger(context, "Falha ao criar localização");
    }
  }

  Future<Event> getById(BuildContext context, int id) async {
    try {
      final response = await _dio.get('$_baseUrl/event-location/$id');
      var data = response.data;
      return Event.fromJson(data);
    } catch (e) {
      MessageSnacks.danger(context, "Erro ao buscar localização pelo id: $e");
      throw Exception();
    }
  }
}
