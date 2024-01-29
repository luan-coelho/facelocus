import 'package:facelocus/dtos/create_ticket_request_dto.dart';
import 'package:facelocus/models/event_request_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';

class EventRequestService {
  final DioFetchApi _fetchApi = DioFetchApi();

  fetchAll(int userId, {int? eventId}) async {
    var url = '${AppRoutes.eventRequest}?user=$userId';
    final response = await _fetchApi.get(url);
    List data = response.data['data'];
    return data.map((json) => EventRequestModel.fromJson(json)).toList();
  }

  createTicketRequest(CreateInvitationDTO eventRequest) async {
    var json = eventRequest.toJson();
    var url = '${AppRoutes.eventRequest}/ticket-request';
    await _fetchApi.post(url, data: json);
  }

  createInvitation(CreateInvitationDTO eventRequest) async {
    var json = eventRequest.toJson();
    var url = '${AppRoutes.eventRequest}/invitation';
    await _fetchApi.post(url, data: json);
  }

  getById(int id) async {
    final response = await _fetchApi.get('${AppRoutes.eventRequest}/$id');
    var data = response.data;
    return EventRequestModel.fromJson(data);
  }

  approve(int eventRequestId, int userId) async {
    var url =
        '${AppRoutes.eventRequest}/approve?eventrequest=$eventRequestId&user=$userId';
    var response = await _fetchApi.patch(url);
    return response.statusCode == 204;
  }

  reject(int eventRequestId, int userId) async {
    var url =
        '${AppRoutes.eventRequest}/reject?eventrequest=$eventRequestId&user=$userId';
    var response = await _fetchApi.patch(url);
    return response.statusCode == 204;
  }
}
