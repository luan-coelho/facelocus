import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('${AppRoutes.eventShow}/${event.id}'),
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        width: double.infinity,
        height: 45,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                event.description!,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
