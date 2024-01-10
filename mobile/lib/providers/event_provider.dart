import 'package:facelocus/models/event.dart';
import 'package:facelocus/services/event_service.dart';
import 'package:flutter/foundation.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  EventModel? _event;
  List<EventModel>? _events;
  bool isLoading = false;

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

  Future<void> create(EventModel event) async {
    isLoading = true;
    notifyListeners();
    await _eventService.create(event);
    isLoading = false;
    notifyListeners();
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
