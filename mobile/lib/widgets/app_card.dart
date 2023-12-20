import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final String text;

  const AppCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0F172A),
        borderRadius: BorderRadius.circular(16),
      ),
      width: 200,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
