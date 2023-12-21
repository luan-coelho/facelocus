import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String description;

  const EventCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 331,
        height: 47,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 1.5),
          ),
        ], borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Center(
            child: Text(description,
                style: const TextStyle(fontWeight: FontWeight.w500))));
  }
}
