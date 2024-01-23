import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';

class EventService {
  final DioFetchApi _fetchApi = DioFetchApi();

  getAllByUser(int userId) async {
    final response = await _fetchApi.get('${AppRoutes.event}?user=$userId');
    List data = response.data['data'];
    return data.map((json) => EventModel.fromJson(json)).toList();
  }

  getAllByDescription(int userId, String description) async {
    var url = '${AppRoutes.event}/search?user=$userId&description=$description';
    final response = await _fetchApi.get(url);
    List data = response.data;
    return data.map((json) => EventModel.fromJson(json)).toList();
  }

  create(EventModel event) async {
    var json = event.toJson();
    await _fetchApi.post(AppRoutes.event, data: json);
  }

  getById(int id) async {
    final response = await _fetchApi.get('${AppRoutes.event}/$id');
    var data = response.data;
    return EventModel.fromJson(data);
  }

  changeTicketRequestPermission(int id) async {
    String url = '${AppRoutes.event}/change-ticket-request-permission/$id';
    var response = await _fetchApi.patch(url);
    return response.statusCode == 204;
  }

  generateNewCode(int id) async {
    String url = '${AppRoutes.event}/generate-new-code/$id';
    var response = await _fetchApi.patch(url);
    return response.statusCode == 204;
  }
}
