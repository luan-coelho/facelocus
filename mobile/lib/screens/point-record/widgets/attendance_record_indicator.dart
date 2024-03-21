import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/models/attendance_record_status_enum.dart';
import 'package:flutter/material.dart';

class AttendanceRecordIndicator extends StatelessWidget {
  const AttendanceRecordIndicator({
    super.key,
    required this.attendanceRecord,
  });

  final AttendanceRecordModel attendanceRecord;

  @override
  Widget build(BuildContext context) {
    final Map<AttendanceRecordStatus, Color> attendanceRecordColor = {
      AttendanceRecordStatus.validated: Colors.green,
      AttendanceRecordStatus.notValidated: Colors.red,
      AttendanceRecordStatus.pending: Colors.amber,
    };

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
