import 'package:facelocus/models/event_request_model.dart';
import 'package:facelocus/models/event_request_status_enum.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventRequestCard extends StatefulWidget {
  const EventRequestCard(
      {super.key, required this.eventRequest, required this.authenticatedUser});

  final EventRequestModel eventRequest;
  final UserModel authenticatedUser;

  @override
  State<EventRequestCard> createState() => _EventRequestCardState();
}

enum EventRequestType { received, sent }

class _EventRequestCardState extends State<EventRequestCard> {
  @override
  Widget build(BuildContext context) {
    EventRequestType getEventRequestType() {
      UserModel authenticatedUser = widget.authenticatedUser;
      if (widget.eventRequest.requestOwner.id == authenticatedUser.id) {
        return EventRequestType.sent;
      }
      return EventRequestType.received;
    }

    String getBannerText() {
      return getEventRequestType() == EventRequestType.received
          ? 'Recebida'
          : 'Enviada';
    }

    Color getBannerColor() {
      return getEventRequestType() == EventRequestType.received
          ? Colors.green
          : Colors.deepPurple;
    }

    Color colorByStatus(EventRequestStatus status) {
      switch (status) {
        case EventRequestStatus.approved:
          return Colors.green;
        case EventRequestStatus.pending:
          return Colors.amber;
        case EventRequestStatus.rejected:
          return Colors.red;
      }
    }

    String descriptionByStatus(EventRequestStatus status) {
      switch (status) {
        case EventRequestStatus.approved:
          return 'Aprovada';
        case EventRequestStatus.pending:
          return 'Pendente';
        case EventRequestStatus.rejected:
          return 'Rejeitada';
      }
    }

    showEventRequest() {
      int eventRequestId = widget.eventRequest.id!;
      context.push(Uri(
          path: '${AppRoutes.eventRequest}/$eventRequestId',
          queryParameters: {
            'eventrequest': widget.eventRequest.id.toString()
          }).toString());
    }

    return GestureDetector(
      onTap: widget.eventRequest.requestStatus == EventRequestStatus.pending
          ? showEventRequest
          : null,
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: const Offset(0, 1.5),
                  ),
                ],
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.eventRequest.event.description!.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color:
                            colorByStatus(widget.eventRequest.requestStatus!),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                        descriptionByStatus(widget.eventRequest.requestStatus!),
                        style: const TextStyle(color: Colors.black54))
                  ],
                )
              ],
            )),
        Positioned(
            top: -10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: getBannerColor()),
                  color: getBannerColor().withOpacity(0.2)),
              child: Text(getBannerText(),
                  style: TextStyle(
                      color: getBannerColor(),
                      fontSize: 10,
                      fontWeight: FontWeight.w500)),
            ))
      ]),
    );
  }
}
