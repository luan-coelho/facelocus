import 'package:facelocus/models/event.dart';
import 'package:facelocus/services/event_service.dart';
import 'package:flutter/foundation.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  Future<Event>? _futureEvent;

  Future<Event>? get futureEvent => _futureEvent;

  /// Faz uma chamada para a API
  void refleshById(int eventId) {
    _futureEvent = _eventService.getById(eventId);
    notifyListeners();
  }
}
