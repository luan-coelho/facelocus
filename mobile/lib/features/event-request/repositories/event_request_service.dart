import 'package:facelocus/dtos/create_ticket_request_dto.dart';
import 'package:facelocus/models/event_request_model.dart';
import 'package:facelocus/models/event_request_type_enum.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';

class EventRequestRepository {
  final DioFetchApi _fetchApi = DioFetchApi();

  Future<List<EventRequestModel>> fetchAll(int userId, {int? eventId}) async {
    var url = '${AppRoutes.eventRequest}?user=$userId';
    final response = await _fetchApi.get(url);
    List data = response.data['data'];
    return data.map((json) => EventRequestModel.fromJson(json)).toList();
  }

  Future<void> createTicketRequest(CreateInvitationDTO eventRequest) async {
    var json = eventRequest.toJson();
    var url = '${AppRoutes.eventRequest}/ticket-request';
    await _fetchApi.post(url, data: json);
  }

  Future<void> createInvitation(CreateInvitationDTO eventRequest) async {
    var json = eventRequest.toJson();
    var url = '${AppRoutes.eventRequest}/invitation';
    await _fetchApi.post(url, data: json);
  }

  Future<EventRequestModel> getById(int id) async {
    final response = await _fetchApi.get('${AppRoutes.eventRequest}/$id');
    var data = response.data;
    return EventRequestModel.fromJson(data);
  }

  Future<bool> approve(
    int eventRequestId,
    int userId,
    EventRequestType requestType,
  ) async {
    String rType = EventRequestType.toJson(requestType);
    var url =
        '${AppRoutes.eventRequest}/approve?eventrequest=$eventRequestId&user=$userId&requesttype=$rType';
    var response = await _fetchApi.patch(url);
    return response.statusCode == 204;
  }

  Future<bool> reject(int eventRequestId) async {
    var url = '${AppRoutes.eventRequest}/reject?eventrequest=$eventRequestId';
    var response = await _fetchApi.patch(url);
    return response.statusCode == 204;
  }
}
