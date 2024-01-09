import 'package:facelocus/providers/event_provider.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/event/widgets/users_accordion.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/feature_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EventShowScreen extends StatefulWidget {
  const EventShowScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<EventShowScreen> createState() => _EventShowScreenState();
}

class _EventShowScreenState extends State<EventShowScreen> {
  late EventProvider _eventProvider;

  @override
  void initState() {
    super.initState();
    _eventProvider = Provider.of<EventProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventProvider.fetchById(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, state, child) {
      return AppLayout(
          appBarTitle: 'Evento',
          body: SingleChildScrollView(
            child: Skeletonizer(
                enabled: state.isLoading,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, right: 30, left: 30, bottom: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            Switch(
                                value: state.event != null
                                    ? state.event!.allowTicketRequests!
                                    : false,
                                onChanged: (_) =>
                                    state.changeTicketRequestPermission(
                                        widget.eventId)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        UsersAccordion(eventId: widget.eventId)
                      ]),
                )),
          ));
    });
  }
}
