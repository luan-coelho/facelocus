import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventHeader extends StatelessWidget {
  const EventHeader({
    super.key,
    required this.description,
    required this.date,
  });

  final String description;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Builder(
          builder: (context) {
            String datef = DateFormat('dd/MM/yyyy').format(date);
            return Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                datef,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
