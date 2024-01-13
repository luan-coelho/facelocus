import 'package:facelocus/models/ticket_request.dart';
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
    return GestureDetector(
      onTap: () => {},
      child: Container(
          padding: const EdgeInsets.all(15),
          width: 330,
          height: 45,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 1.5),
            ),
          ], color: Colors.white),
          child: Column(
            children: [
              Text(widget.ticketRequest.event.description!.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          )),
    );
  }
}
