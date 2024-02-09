import 'package:facelocus/models/point_model.dart';
import 'package:flutter/material.dart';

class AttendanceRecordIndicator extends StatelessWidget {
  const AttendanceRecordIndicator({super.key, required this.point});

  final PointModel point;

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
