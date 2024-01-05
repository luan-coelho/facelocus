import 'package:facelocus/models/event.dart';
import 'package:flutter/foundation.dart';

class EventProvider with ChangeNotifier {
  Event event = Event.empty();

  void clean() {
    event = Event.empty();
  }
}
