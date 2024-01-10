import 'package:facelocus/models/event.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/event/widgets/event_card.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/event_service.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  List<EventCard> events = [];
  late EventService _eventService;

  @override
  void initState() {
    _eventService = EventService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Eventos',
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<List<EventModel>>(
                future: _eventService.getAll(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Ainda não há nenhum evento cadastrado',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 20);
                      },
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var event = snapshot.data![index];
                        return EventCard(event: event);
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.eventCreate),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white, size: 29),
      ),
    );
  }
}
