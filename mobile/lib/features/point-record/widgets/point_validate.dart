import 'package:facelocus/models/attendance_record_status_enum.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../models/attendance_record_model.dart';
import '../../../models/point_model.dart';

class PointValidate extends StatefulWidget {
  const PointValidate({
    super.key,
    required this.attendanceRecord,
    required this.pointRecord,
  });

  final AttendanceRecordModel attendanceRecord;
  final PointRecordModel pointRecord;

  @override
  State<PointValidate> createState() => _PointValidateState();
}

class _PointValidateState extends State<PointValidate> {
  bool fitForValidation = false;

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
    bool checkIfFitForValidation() {
      AttendanceRecordModel ar = widget.attendanceRecord;
      PointModel point = ar.point;
      AttendanceRecordStatus? status = ar.status;
      DateTime initialDate = point.initialDate;
      DateTime finalDate = point.finalDate;
      DateTime now = DateTime.now();

      if (!now.isBefore(initialDate) &&
          !now.isAfter(finalDate) &&
          status == AttendanceRecordStatus.pending) {
        return true;
      }
      return false;
    }

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: attendanceRecordColor[widget.attendanceRecord.status]!,
            width: 16,
          ),
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
            Builder(
              builder: (context) {
                final DateFormat formatter = DateFormat('HH:mm');
                final String initialDate = formatter.format(
                  widget.attendanceRecord.point.initialDate,
                );
                final String finalDate = formatter.format(
                  widget.attendanceRecord.point.finalDate,
                );
                return Text(
                  '$initialDate - $finalDate',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                );
              },
            ),
            if (checkIfFitForValidation()) ...[
              AppButton(
                text: 'Validar',
                width: 100,
                height: 40,
                onPressed: () => checkIfFitForValidation()
                    ? context.push(
                        Uri(
                          path: AppRoutes.validateFactors,
                          queryParameters: {
                            'attendanceRecord':
                                widget.attendanceRecord.id.toString(),
                            'faceRecognitionFactor': widget.pointRecord.factors!
                                .contains(Factor.facialRecognition)
                                .toString(),
                            'locationIndoorFactor': widget.pointRecord.factors!
                                .contains(Factor.location)
                                .toString(),
                          },
                        ).toString(),
                      )
                    : null,
              ),
            ] else ...[
              SizedBox(
                height: 45.0,
                width: 45.0,
                child: IconButton(
                  padding: const EdgeInsets.all(0.0),
                  onPressed: null,
                  icon: Icon(
                    attendanceRecordStatus[widget.attendanceRecord.status],
                    size: 35.0,
                  ),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                      attendanceRecordColor[widget.attendanceRecord.status]!,
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
