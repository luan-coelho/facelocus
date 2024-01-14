import 'package:dio/dio.dart';
import 'package:facelocus/models/event.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/providers/auth_provider.dart';
import 'package:facelocus/services/event_service.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  EventModel? _event;
  List<EventModel>? _events = [];
  bool isLoading = false;
  Map<String, dynamic>? invalidFields;

  EventModel? get event => _event;

  List<EventModel>? get events => _events;

  Future<void> fetchAll() async {
    isLoading = true;
    notifyListeners();
    _events = await _eventService.getAll();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchById(int eventId) async {
    isLoading = true;
    notifyListeners();
    _event = await _eventService.getById(eventId);
    isLoading = false;
    notifyListeners();
  }

  Future<void> create(BuildContext context, EventModel event) async {
    isLoading = true;
    notifyListeners();
    try {
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      UserModel administrator = authProvider.authenticatedUser;
      event.administrator = administrator;
      await _eventService.create(event);
      MessageSnacks.success(context, 'Evento criado com sucesso');
      context.pop();
    } on DioException catch (e) {
      String detail = onError(e, message: 'Falha ao criar evento');
      MessageSnacks.danger(context, detail);
    }
    fetchAll();
  }

  String onError(DioException e, {String? message}) {
    if (e.response?.data == Map && e.response?.data['detail'] != null) {
      String detail = e.response?.data.containsKey('detail');
      if (e.response?.data['invalidFields'] != null) {
        invalidFields = e.response?.data['invalidFields'];
      }
      return detail;
    }
    return message ?? 'Falha ao executar esta ação';
  }

  Future<void> changeTicketRequestPermission(int eventId) async {
    await _eventService.changeTicketRequestPermission(eventId);
    fetchById(eventId);
  }

  Future<void> generateNewCode(int eventId) async {
    await _eventService.generateNewCode(eventId);
    fetchById(eventId);
  }
}
