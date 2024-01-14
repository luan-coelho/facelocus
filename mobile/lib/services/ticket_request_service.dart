import 'package:facelocus/dtos/ticket_request_create.dart';
import 'package:facelocus/models/ticket_request.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';

class TicketRequestService {
  final DioFetchApi _fetchApi = DioFetchApi();

  Future<List<TicketRequestModel>> getAllByUser(int userId) async {
    final response =
        await _fetchApi.get('${AppRoutes.ticketRequestByUser}/?user=$userId');
    List data = response.data['data'];
    return data.map((json) => TicketRequestModel.fromJson(json)).toList();
  }

  Future<void> create(TicketRequestCreate ticketRequest) async {
    var json = ticketRequest.toJson();
    await _fetchApi.post(AppRoutes.ticketRequest, data: json);
  }

  Future<TicketRequestModel> getById(int id) async {
    final response = await _fetchApi.get('${AppRoutes.ticketRequest}/$id');
    var data = response.data;
    return TicketRequestModel.fromJson(data);
  }

  Future<bool> aprove(int ticketRequestId, int userId) async {
    String url =
        '${AppRoutes.ticketRequest}/aprove?ticketrequest=$ticketRequestId&user=$userId';
    var response = await _fetchApi.patch(url);
    return response.statusCode == 204;
  }

  Future<bool> reject(int ticketRequestId, int userId) async {
    String url =
        '${AppRoutes.ticketRequest}/reject?ticketrequest=$ticketRequestId&user=$userId';
    var response = await _fetchApi.patch(url);
    return response.statusCode == 204;
  }
}
