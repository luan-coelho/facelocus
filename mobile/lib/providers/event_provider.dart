import 'package:facelocus/models/event.dart';
import 'package:facelocus/models/location.dart';
import 'package:flutter/foundation.dart';

class EventProvider with ChangeNotifier {
  Event _event = Event.empty();

  Event get event => _event;

  void clean() {
    _event = Event.empty();
  }

  void change(Event event) {
    _event = event;
  }

  void addLocation(Location location) {
    _event.locations ??= [];
    _event.locations?.add(location);
    notifyListeners();
  }

  void deleteLocation(Location location) {
    _event.locations?.remove(location);
    notifyListeners();
  }
}
