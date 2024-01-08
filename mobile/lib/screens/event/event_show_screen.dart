import 'package:facelocus/models/event.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/services/event_service.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/feature_card.dart';
import 'package:flutter/material.dart';

class EventShowScreen extends StatefulWidget {
  const EventShowScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<EventShowScreen> createState() => _EventShowScreenState();
}

class _EventShowScreenState extends State<EventShowScreen> {
  @override
  void initState() {
    super.initState();
    _eventService = EventService();
    _futureEvent = _eventService.getById(widget.eventId);
  }

  late EventService _eventService;
  late Future<Event> _futureEvent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evento')),
      body: FutureBuilder(
          future: _futureEvent,
          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao buscar dados'));
            }
            Event event = snapshot.data!;

            void updateSwith() async {
              bool success =
                  await _eventService.changeTicketRequestPermission(event.id!);
              if (success) {
                setState(() {
                  event.allowTicketRequests = !event.allowTicketRequests!;
                });
              }
            }

            return Padding(
                padding: const EdgeInsets.only(
                    top: 20, right: 30, left: 30, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.description!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FeatureCard(
                            description: 'Usuários',
                            route: AppRoutes.eventLocations,
                            color: Colors.white,
                            backgroundColor: AppColorsConst.blue,
                            imageName: 'users-icon.svg',
                            width: 150),
                        const SizedBox(width: 15),
                        FeatureCard(
                            description: 'Localizações',
                            route: Uri(
                                path: AppRoutes.eventLocations,
                                queryParameters: {
                                  'event': widget.eventId.toString()
                                }).toString(),
                            color: Colors.black,
                            backgroundColor: AppColorsConst.yellow,
                            imageName: 'locations-icon.svg',
                            width: 150),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Flexible(
                          child: Text(
                              'Permitir que outros participantes enviem solicitações para ingresso',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        Switch(
                            value: event.allowTicketRequests!,
                            onChanged: (_) => updateSwith()),
                      ],
                    ),
                  ],
                ));
          }),
    );
  }

  getDeviceLocation() {}
}
