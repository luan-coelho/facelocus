import 'package:facelocus/features/point-record/blocs/attendance-record/attendance_record_bloc.dart';
import 'package:facelocus/features/point-record/blocs/point-record-show/point_record_show_bloc.dart';
import 'package:facelocus/features/point-record/widgets/fr_factor_validate_card.dart';
import 'package:facelocus/features/point-record/widgets/il_factor_validate_card.dart';
import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ValidateFactorsScreen extends StatefulWidget {
  const ValidateFactorsScreen({
    super.key,
    required this.attendanceRecordId,
    required this.faceRecognitionFactor,
    required this.locationIndoorFactor,
  });

  final int attendanceRecordId;
  final bool faceRecognitionFactor;
  final bool locationIndoorFactor;

  @override
  State<ValidateFactorsScreen> createState() => _ValidateFactorsScreenState();
}

class _ValidateFactorsScreenState extends State<ValidateFactorsScreen> {
  @override
  void initState() {
    context.read<AttendanceRecordBloc>().add(
          LoadAttendanceRecord(attendanceRecordId: widget.attendanceRecordId),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Validar Fatores',
      showBottomNavigationBar: false,
      body: Padding(
        padding: const EdgeInsets.all(29.0),
        child: BlocBuilder<AttendanceRecordBloc, AttendanceRecordState>(
          builder: (context, state) {
            if (state is AttendanceRecordLoaded) {
              AttendanceRecordModel ar = state.attendanceRecord;
              return Column(
                children: [
                  if (widget.locationIndoorFactor) ...[
                    GestureDetector(
                      onTap: !ar.locationValidatedSuccessfully
                          ? () => context.push(
                                '${AppRoutes.locationFactorValidate}/${widget.attendanceRecordId}',
                              )
                          : null,
                      child: LocationFactorValidateCard(
                        attendanceRecord: ar,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (widget.faceRecognitionFactor) ...[
                    GestureDetector(
                      onTap: () => context.push(
                        '${AppRoutes.facialFactorValidate}/${widget.attendanceRecordId}',
                      ),
                      child: BlocBuilder<PointRecordShowBloc,
                          PointRecordShowState>(
                        builder: (context, state) {
                          if (state is PointRecordShowLoaded) {
                            return FrFactorValidateCard(
                              factor: Factor.facialRecognition,
                              blocked: state.pointRecord.factors!
                                      .contains(Factor.location) &&
                                  !ar.locationValidatedSuccessfully,
                            );
                          }
                          return const Center(child: Spinner());
                        },
                      ),
                    )
                  ]
                ],
              );
            }
            return const Center(child: Spinner());
          },
        ),
      ),
    );
  }
}
