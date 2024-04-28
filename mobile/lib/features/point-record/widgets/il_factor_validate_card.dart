import 'package:facelocus/models/attendance_record_status_enum.dart';
import 'package:flutter/material.dart';

import '../../../models/attendance_record_model.dart';

class LocationFactorValidateCard extends StatefulWidget {
  const LocationFactorValidateCard({
    super.key,
    required this.attendanceRecord,
  });

  final AttendanceRecordModel attendanceRecord;

  @override
  State<LocationFactorValidateCard> createState() =>
      _LocationFactorValidateCardState();
}

class _LocationFactorValidateCardState
    extends State<LocationFactorValidateCard> {
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

  getColorByStatus(AttendanceRecordStatus status) {
    if (widget.attendanceRecord.locationValidatedSuccessfully) {
      return attendanceRecordColor[AttendanceRecordStatus.validated]!;
    }
    return attendanceRecordColor[status]!;
  }

  getIconByStatus(AttendanceRecordStatus status) {
    if (widget.attendanceRecord.locationValidatedSuccessfully) {
      return attendanceRecordStatus[AttendanceRecordStatus.validated]!;
    }
    return attendanceRecordStatus[status]!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              color: getColorByStatus(widget.attendanceRecord.status),
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
            const Text(
              'Localização',
              style: TextStyle(
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
                  getIconByStatus(widget.attendanceRecord.status),
                  size: 35.0,
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    getColorByStatus(widget.attendanceRecord.status),
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
