import 'package:facelocus/models/ticket_request.dart';
import 'package:facelocus/models/ticket_request_status.dart';
import 'package:flutter/material.dart';

class TicketRequestCard extends StatefulWidget {
  const TicketRequestCard({super.key, required this.ticketRequest});

  final TicketRequestModel ticketRequest;

  @override
  State<TicketRequestCard> createState() => _TicketRequestCardState();
}

class _TicketRequestCardState extends State<TicketRequestCard> {
  @override
  Widget build(BuildContext context) {
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
      child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 1.5),
            ),
          ], color: Colors.white),
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
                      color: colorByStatus(widget.ticketRequest.requestStatus),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(descriptionByStatus(widget.ticketRequest.requestStatus), style: const TextStyle(
                    color: Colors.black54
                  ))
                ],
              )
            ],
          )),
    );
  }
}
