import 'package:flutter/material.dart';

class InformationField extends StatelessWidget {
  const InformationField(
      {super.key, required this.description, required this.value});

  final String description;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(description, style: const TextStyle(fontWeight: FontWeight.w500)),
      const SizedBox(height: 5),
      Text(value)
    ]);
  }
}
