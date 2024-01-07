import 'package:dio/dio.dart';
import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';

class LocationService {
  final Dio _dio = Dio();
  final String _baseUrl = AppConfigConst.baseApiUrl;

  Future<List<LocationModel>> getAllByEventId(int eventId) async {
    final response =
        await _dio.get('$_baseUrl${AppRoutes.eventLocations}?event=$eventId');
    List<dynamic> data = response.data;
    return data.map((json) => LocationModel.fromJson(json)).toList();
  }

  Future<void> create(LocationModel location, int eventId) async {
    var json = location.toJson();
    String url = '$_baseUrl${AppRoutes.eventLocations}?event=$eventId';
    await _dio.post(url, data: json);
  }

  Future<LocationModel> getById(int id) async {
    String url = "$_baseUrl${AppRoutes.eventLocations}/$id";
    final response = await _dio.get(url);
    var data = response.data;
    return LocationModel.fromJson(data);
  }

  Future<void> deleteById(int id) async {
    await _dio.delete("$_baseUrl${AppRoutes.eventLocations}/$id");
  }
}
