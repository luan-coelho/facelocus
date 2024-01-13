import 'package:facelocus/models/event.dart';
import 'package:facelocus/providers/event_provider.dart';
import 'package:facelocus/screens/event/event_create_screen.dart';
import 'package:facelocus/screens/event/widgets/event_card.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late EventProvider _eventProvider;

  @override
  void initState() {
    _eventProvider = Provider.of<EventProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventProvider.fetchAll();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showDataAlert() {
      showDialog(
          context: context,
          builder: (context) {
            return const EventCreateForm();
          });
    }

    return AppLayout(
      appBarTitle: 'Eventos',
      body: Consumer<EventProvider>(builder: (context, state, child) {
        if (!state.isLoading && state.events!.isEmpty) {
          return const EmptyData('Você ainda não criou nenhum evento');
        }

        return Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Skeletonizer(
            enabled: state.isLoading,
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 15, right: 15),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 20);
              },
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: state.events!.length,
              itemBuilder: (context, index) {
                EventModel event = state.events![index];
                return EventCard(event: event);
              },
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: showDataAlert,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white, size: 29),
      ),
    );
  }
}
