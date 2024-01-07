import 'package:dio/dio.dart';
import 'package:facelocus/models/event.dart';
import 'package:facelocus/models/location.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/message_snacks.dart';

class LocationService {
  final Dio _dio = Dio();
  final String _baseUrl = "http://10.0.2.2:8080";

  Future<List<Location>> getAllByEventId(context, int eventId) async {
    try {
      final response =
          await _dio.get('$_baseUrl${AppRoutes.eventLocations}?event=$eventId');
      List<dynamic> data = response.data;
      return data.map((json) => Location.fromJson(json)).toList();
    } catch (e) {
      MessageSnacks.danger(context, "Falha ao buscar localizações");
      throw Exception("Falha ao buscar localizações: $e");
    }
  }

  Future<void> create(context, Location location, int eventId) async {
    try {
      var json = location.toJson();
      String url = '$_baseUrl${AppRoutes.eventLocations}?event=$eventId';
      await _dio.post(url, data: json);
      MessageSnacks.success(context, "Localização cadastrada com sucesso");
    } catch (e) {
      MessageSnacks.danger(context, "Falha ao criar localização");
    }
  }

  Future<Event> getById(context, int id) async {
    try {
      String url = "$_baseUrl${AppRoutes.eventLocations}/$id";
      final response = await _dio.get(url);
      var data = response.data;
      return Event.fromJson(data);
    } catch (e) {
      MessageSnacks.danger(context, "Falha ao buscar localização pelo id: $e");
      throw Exception();
    }
  }

  Future<void> deleteById(int id) async {
    await _dio.delete("$_baseUrl${AppRoutes.eventLocations}/$id");
  }
}
