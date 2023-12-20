import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String description;
  final String route;
  final Color? color;

  const FeatureCard(
      {super.key, required this.description, required this.route, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            description,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
