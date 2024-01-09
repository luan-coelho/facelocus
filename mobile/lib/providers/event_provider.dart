import 'package:facelocus/models/event.dart';
import 'package:facelocus/services/event_service.dart';
import 'package:flutter/foundation.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  Event? _event;
  bool isLoading = false;

  Event? get event => _event;

  Future<void> fetchById(int eventId) async {
    isLoading = true;
    notifyListeners();

    _event = await _eventService.getById(eventId);

    isLoading = false;
    notifyListeners();
  }

  Future<void> changeTicketRequestPermission(int eventId) async {
    await _eventService.changeTicketRequestPermission(eventId);
    fetchById(eventId);
  }
}
