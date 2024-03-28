import 'package:facelocus/models/attendance_record_status_enum.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/models/user_attendace_model.dart';
import 'package:flutter/material.dart';

import '../../../models/attendance_record_model.dart';

class ILFactorValidateCard extends StatefulWidget {
  const ILFactorValidateCard({
    super.key,
    required this.userAttendance,
    this.attendanceRecord,
    this.pointRecord,
    required this.factor,
  });

  final UserAttendanceModel userAttendance;
  final AttendanceRecordModel? attendanceRecord;
  final PointRecordModel? pointRecord;
  final Factor factor;

  @override
  State<ILFactorValidateCard> createState() => _ILFactorValidateCardState();
}

class _ILFactorValidateCardState extends State<ILFactorValidateCard> {
  final Map<AttendanceRecordStatus, IconData> attendanceRecordStatus = {
    AttendanceRecordStatus.validated: Icons.check_circle,
    AttendanceRecordStatus.notValidated: Icons.dangerous,
    AttendanceRecordStatus.pending: Icons.pending,
  };

  final Map<AttendanceRecordStatus, Color> attendanceRecordColor = {
    AttendanceRecordStatus.validated: Colors.green,
    AttendanceRecordStatus.notValidated: Colors.red,
    AttendanceRecordStatus.pending: Colors.amber,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              color: attendanceRecordColor[AttendanceRecordStatus.pending]!,
              width: 16),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.factor.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 45.0,
              width: 45.0,
              child: IconButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: null,
                icon: Icon(
                  attendanceRecordStatus[AttendanceRecordStatus.pending],
                  size: 35.0,
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    attendanceRecordColor[AttendanceRecordStatus.pending]!,
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
