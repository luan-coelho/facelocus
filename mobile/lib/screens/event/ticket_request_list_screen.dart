import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/controllers/ticket_request_controller.dart';
import 'package:facelocus/screens/event/widgets/ticket_request_card.dart';
import 'package:facelocus/services/ticket_request_service.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:facelocus/shared/widgets/unexpected_error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TicketRequestListScreen extends StatefulWidget {
  const TicketRequestListScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<TicketRequestListScreen> createState() =>
      _TicketRequestListScreenState();
}

class _TicketRequestListScreenState extends State<TicketRequestListScreen> {
  late final TicketRequestController _controller;
  late final AuthController _authController;

  @override
  void initState() {
    _controller = TicketRequestController(service: TicketRequestService());
    _controller.fetchAll(eventId: widget.eventId);
    _authController = Get.find<AuthController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
        appBarTitle: 'Solicitações',
        body: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Obx(() {
            if (!_controller.isLoading.value &&
                _controller.ticketsRequest!.isEmpty) {
              const message = 'Nenhuma solicitação no momento';
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
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 20);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _controller.ticketsRequest!.length,
                  itemBuilder: (context, index) {
                    var ticketsRequest = _controller.ticketsRequest![index];
                    return TicketRequestCard(
                        ticketRequest: ticketsRequest,
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
