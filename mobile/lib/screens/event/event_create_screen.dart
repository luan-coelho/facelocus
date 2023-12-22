import 'package:flutter/material.dart';
import 'package:mobile/models/event.dart';
import 'package:mobile/services/event_service.dart';
import 'package:mobile/widgets/event/event_card.dart';

class EventCreateScreen extends StatefulWidget {
  const EventCreateScreen({super.key});

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  List<EventCard> events = [];
  late EventService _eventService;

  @override
  void initState() {
    _eventService = EventService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Eventos")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [],
          ),
        ),
    );
  }
}
