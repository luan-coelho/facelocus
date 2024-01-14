import 'package:facelocus/controllers/event_controller.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/event/widgets/event_code_card.dart';
import 'package:facelocus/services/event_service.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/feature_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EventShowScreen extends StatefulWidget {
  const EventShowScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<EventShowScreen> createState() => _EventShowScreenState();
}

class _EventShowScreenState extends State<EventShowScreen> {
  late EventController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EventController(eventService: EventService());
    _controller.fetchById(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AppLayout(
          appBarTitle: _controller.event?.description ?? 'Evento',
          body: SingleChildScrollView(
            child: Skeletonizer(
                enabled: _controller.isLoading.value,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, right: 30, left: 30, bottom: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FeatureCard(
                                description: 'Usuários',
                                route: Uri(
                                    path: AppRoutes.eventUsers,
                                    queryParameters: {
                                      'event': widget.eventId.toString()
                                    }).toString(),
                                color: Colors.white,
                                backgroundColor: AppColorsConst.blue,
                                imageName: 'users-icon.svg',
                                width: 130,
                                height: 100),
                            const SizedBox(width: 15),
                            FeatureCard(
                                description: 'Localizações',
                                route: Uri(
                                    path: AppRoutes.eventLocations,
                                    queryParameters: {
                                      'event': widget.eventId.toString()
                                    }).toString(),
                                color: Colors.black,
                                backgroundColor: AppColorsConst.white,
                                imageName: 'locations-icon.svg',
                                width: 130,
                                height: 100),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Flexible(
                              child: Text('Permitir solicitações de ingresso',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            Switch(
                                value: _controller.event != null
                                    ? _controller.event!.allowTicketRequests!
                                    : false,
                                onChanged: (_) =>
                                    _controller.changeTicketRequestPermission(
                                        widget.eventId)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        !_controller.isLoading.value &&
                                _controller.event != null &&
                                _controller.event!.allowTicketRequests! == true
                            ? EventCodeCard(event: _controller.event!)
                            : const SizedBox(),
                      ]),
                )),
          ));
    });
  }
}
