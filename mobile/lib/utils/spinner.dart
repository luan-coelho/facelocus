import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          ),
          if (label != null) Text(label!),
        ],
      ),
    );
  }
}
