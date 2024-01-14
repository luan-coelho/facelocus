import 'package:dio/dio.dart';
import 'package:facelocus/dtos/event_ticket_request_create.dart';
import 'package:facelocus/dtos/ticket_request_create.dart';
import 'package:facelocus/models/event.dart';
import 'package:facelocus/models/ticket_request.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/providers/auth_provider.dart';
import 'package:facelocus/services/ticket_request_service.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TicketRequestProvider with ChangeNotifier {
  final TicketRequestService _ticketRequestService = TicketRequestService();
  TicketRequestModel? _ticketRequest;
  List<TicketRequestModel>? _ticketsRequest = [];
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? invalidFields;

  TicketRequestModel get ticketRequest => _ticketRequest!;

  List<TicketRequestModel>? get ticketsRequest => _ticketsRequest;

  Future<void> fetchAllByUser(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      int userId = authProvider.authenticatedUser.id!;
      _ticketsRequest = await _ticketRequestService.getAllByUser(userId);
      isLoading = false;
    } on DioException catch (e) {
      String detail = onError(e, message: 'Falha ao buscar solicitações');
      error = detail;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchById(int userId) async {
    isLoading = true;
    notifyListeners();
    _ticketRequest = await _ticketRequestService.getById(userId);
    isLoading = false;
    notifyListeners();
  }

  Future<void> createByCode(BuildContext context, String code) async {
    isLoading = true;
    notifyListeners();
    try {
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      UserModel user = authProvider.authenticatedUser;
      EventTicketRequestCreate event = EventTicketRequestCreate(user: user);
      event.code = code;
      TicketRequestCreate ticketRequest =
          TicketRequestCreate(event: event, user: user);
      await _ticketRequestService.create(ticketRequest);
      String message = 'Solicitação de ingresso enviada com sucesso';
      MessageSnacks.success(context, message);
      context.pop();
    } on DioException catch (e) {
      String detail = onError(e);
      MessageSnacks.danger(context, detail);
    }
    fetchAllByUser(context);
  }

  String onError(DioException e, {String? message}) {
    if (e.response?.data != null && e.response?.data['detail'] != null) {
      String detail = e.response?.data['detail'];
      if (e.response?.data['invalidFields'] != null) {
        invalidFields = e.response?.data['invalidFields'];
      }
      return detail;
    }
    return message ?? 'Falha ao executar esta ação';
  }
}
