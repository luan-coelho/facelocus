import 'package:dio/dio.dart';
import 'package:facelocus/models/event.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/widgets.dart';

class EventService {
  final Dio _dio = Dio();
  final String _baseUrl = "http://10.0.2.2:8080";

  Future<List<Event>> getAll() async {
    try {
      final response = await _dio.get('$_baseUrl/event');
      List data = response.data['data'];
      return data.map((json) => Event.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Erro ao buscar eventos: $e");
    }
  }

  Future<void> create(BuildContext context, Event event) async {
    try {
      var json = event.toJson();
      await _dio.post('$_baseUrl/event', data: json);
      MessageSnacks.success(context, "Evento cadastrado com sucesso");
    } catch (e) {
      MessageSnacks.danger(context, "Falha ao criar evento");
    }
  }

  Future<Event> getById(BuildContext context, int id) async {
    try {
      final response = await _dio.get('$_baseUrl/event/$id');
      var data = response.data;
      return Event.fromJson(data);
    } catch (e) {
      MessageSnacks.danger(context, "Erro ao buscar evento pelo id: $e");
      throw Exception();
    }
  }

  Future<bool> changeTicketRequestPermission(
      BuildContext context, int id) async {
    try {
      String url = "$_baseUrl/event/change-ticket-request-permission/$id";
      var response = await _dio.patch(url);
      return response.statusCode == 204;
    } catch (e) {
      MessageSnacks.danger(context, "Houve um problema ao alterar a permissão");
      return false;
    }
  }
}
