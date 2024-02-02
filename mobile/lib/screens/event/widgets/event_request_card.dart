import 'package:facelocus/models/event_request_model.dart';
import 'package:facelocus/models/event_request_status_enum.dart';
import 'package:facelocus/models/event_request_type_enum.dart';
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

enum RequestType { received, sent }

class _EventRequestCardState extends State<EventRequestCard> {
  @override
  Widget build(BuildContext context) {
    RequestType getEventRequestType() {
      UserModel authenticatedUser = widget.authenticatedUser;
      if (widget.eventRequest.requestOwner.id == authenticatedUser.id) {
        return RequestType.sent;
      }
      return RequestType.received;
    }

    String getBannerText() {
      return getEventRequestType() == RequestType.received
          ? 'Recebida'
          : 'Enviada';
    }

    Color getBannerColor() {
      return getEventRequestType() == RequestType.received
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
      EventRequestType requestType = EventRequestType.invitation;
      if (widget.authenticatedUser.id ==
          widget.eventRequest.event.administrator!.id) {
        requestType = EventRequestType.ticketRequest;
      }
      context.push(Uri(
          path: '${AppRoutes.eventRequest}/$eventRequestId',
          queryParameters: {
            'eventrequest': widget.eventRequest.id.toString(),
            'requesttype': requestType
          }).toString());
    }

    return GestureDetector(
      onTap: widget.eventRequest.event.administrator!.id ==
                  widget.authenticatedUser.id &&
              widget.eventRequest.requestStatus == EventRequestStatus.pending
          ? showEventRequest
          : null,
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
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
                      width: 15.0,
                      height: 15.0,
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
            top: 10,
            right: 10,
            child: Container(
              padding:
                  const EdgeInsets.only(top: 4, right: 8, left: 8, bottom: 4),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: getBannerColor()),
                  color: getBannerColor().withOpacity(0.1)),
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
