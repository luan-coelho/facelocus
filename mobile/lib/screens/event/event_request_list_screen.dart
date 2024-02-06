import 'package:facelocus/controllers/auth/session_controller.dart';
import 'package:facelocus/controllers/event_request_controller.dart';
import 'package:facelocus/screens/event/widgets/event_request_card.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:facelocus/shared/widgets/unexpected_error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EventRequestListScreen extends StatefulWidget {
  const EventRequestListScreen({super.key});

  @override
  State<EventRequestListScreen> createState() => _EventRequestListScreenState();
}

class _EventRequestListScreenState extends State<EventRequestListScreen> {
  late final EventRequestController _controller;
  late final SessionController _authController;

  @override
  void initState() {
    _controller = Get.find<EventRequestController>();
    _authController = Get.find<SessionController>();
    _controller.fetchAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
        appBarTitle: 'Solicitações',
        body: Padding(
          padding: const EdgeInsets.all(29),
          child: Obx(() {
            if (!_controller.isLoading.value &&
                _controller.eventsRequest!.isEmpty) {
              const message = 'Nada no momento';
              return const EmptyData(message,
                  child: AppButton(text: 'Adicionar', onPressed: null));
            }

            if (!_controller.isLoading.value && _controller.error != null) {
              return UnexpectedError(_controller.error!);
            }

            return SingleChildScrollView(
              child: Skeletonizer(
                enabled: _controller.isLoading.value,
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 20);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _controller.eventsRequest!.length,
                  itemBuilder: (context, index) {
                    var eventRequest = _controller.eventsRequest![index];
                    return EventRequestCard(
                        eventRequest: eventRequest,
                        authenticatedUser:
                            _authController.authenticatedUser.value!);
                  },
                ),
              ),
            );
          }),
        ),
        floatingActionButton: const FloatingActionButton(
          onPressed: null,
          backgroundColor: Colors.green,
          child: Icon(Icons.add, color: Colors.white, size: 29),
        ));
  }
}
