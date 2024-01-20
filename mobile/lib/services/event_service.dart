import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';

class EventService {
  final DioFetchApi _fetchApi = DioFetchApi();

  Future<List<EventModel>> getAllByUser(int userId) async {
    final response = await _fetchApi.get('${AppRoutes.event}?user=$userId');
    List data = response.data['data'];
    return data.map((json) => EventModel.fromJson(json)).toList();
  }

  Future<void> create(EventModel event) async {
    var json = event.toJson();
    await _fetchApi.post(AppRoutes.event, data: json);
  }

  Future<EventModel> getById(int id) async {
    final response = await _fetchApi.get('${AppRoutes.event}/$id');
    var data = response.data;
    return EventModel.fromJson(data);
  }

  Future<bool> changeTicketRequestPermission(int id) async {
    String url = '${AppRoutes.event}/change-ticket-request-permission/$id';
    var response = await _fetchApi.patch(url);
    return response.statusCode == 204;
  }

  Future<bool> generateNewCode(int id) async {
    String url = '${AppRoutes.event}/generate-new-code/$id';
    var response = await _fetchApi.patch(url);
    return response.statusCode == 204;
  }
}
