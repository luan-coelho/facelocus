import 'package:facelocus/models/ticket_request.dart';
import 'package:facelocus/models/ticket_request_status.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:flutter/material.dart';

class TicketRequestCard extends StatefulWidget {
  const TicketRequestCard(
      {super.key,
      required this.ticketRequest,
      required this.authenticatedUser});

  final TicketRequestModel ticketRequest;
  final UserModel authenticatedUser;

  @override
  State<TicketRequestCard> createState() => _TicketRequestCardState();
}

enum TicketRequestType { received, sent }

class _TicketRequestCardState extends State<TicketRequestCard> {
  @override
  Widget build(BuildContext context) {
    TicketRequestType getTicketRequestType() {
      UserModel authenticatedUser = widget.authenticatedUser;
      if (widget.ticketRequest.user.id == authenticatedUser.id) {
        return TicketRequestType.sent;
      }
      return TicketRequestType.received;
    }

    String getBannerText() {
      return getTicketRequestType() == TicketRequestType.received
          ? 'Recebida'
          : 'Enviada';
    }

    Color getBannerColor() {
      return getTicketRequestType() == TicketRequestType.received
          ? Colors.green
          : Colors.deepPurple;
    }

    Color colorByStatus(TicketRequestStatus status) {
      switch (status) {
        case TicketRequestStatus.approved:
          return Colors.green;
        case TicketRequestStatus.pending:
          return Colors.amber;
        case TicketRequestStatus.rejected:
          return Colors.red;
      }
    }

    String descriptionByStatus(TicketRequestStatus status) {
      switch (status) {
        case TicketRequestStatus.approved:
          return 'Aprovada';
        case TicketRequestStatus.pending:
          return 'Pendente';
        case TicketRequestStatus.rejected:
          return 'Rejeitada';
      }
    }

    return GestureDetector(
      onTap: () => {},
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
                Text(widget.ticketRequest.event.description!.toUpperCase(),
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
                            colorByStatus(widget.ticketRequest.requestStatus!),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                        descriptionByStatus(
                            widget.ticketRequest.requestStatus!),
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
