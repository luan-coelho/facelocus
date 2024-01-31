import 'package:flutter/material.dart';

class AttendanceRecordIndicator extends StatelessWidget {
  const AttendanceRecordIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15.0,
      height: 15.0,
      decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black)),
    );
  }
}
