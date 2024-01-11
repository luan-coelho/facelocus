import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';

class LocationService {
  final DioFetchApi _fetchApi = DioFetchApi();

  Future<List<LocationModel>> getAllByEventId(int eventId) async {
    final response =
        await _fetchApi.get('${AppRoutes.eventLocations}?event=$eventId');
    List<dynamic> data = response.data;
    return data.map((json) => LocationModel.fromJson(json)).toList();
  }

  Future<void> create(LocationModel location, int eventId) async {
    var json = location.toJson();
    String url = '${AppRoutes.eventLocations}?event=$eventId';
    await _fetchApi.post(url, data: json);
  }

  Future<LocationModel> getById(int id) async {
    String url = "${AppRoutes.eventLocations}/$id";
    final response = await _fetchApi.get(url);
    var data = response.data;
    return LocationModel.fromJson(data);
  }

  Future<void> deleteById(int id) async {
    await _fetchApi.delete("${AppRoutes.eventLocations}/$id");
  }
}
