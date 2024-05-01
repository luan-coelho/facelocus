import 'package:facelocus/features/point-record/blocs/user-attendance-validate/user_attendance_validate_bloc.dart';
import 'package:facelocus/features/point-record/widgets/attendance_record_indicator.dart';
import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/models/attendance_record_status_enum.dart';
import 'package:facelocus/models/user_attendace_model.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class UserAttendanceValidateCard extends StatefulWidget {
  const UserAttendanceValidateCard({
    super.key,
    required this.userAttendance,
    required this.pointRecordId,
  });

  final UserAttendanceModel userAttendance;
  final int pointRecordId;

  @override
  State<StatefulWidget> createState() => _UserAttendanceValidateCardState();
}

class _UserAttendanceValidateCardState
    extends State<UserAttendanceValidateCard> {
  late List<MultiSelectItem<AttendanceRecordModel?>> _points;
  final List<AttendanceRecordModel?> _selectedPoints = [];

  @override
  void initState() {
    _points = widget.userAttendance.attendanceRecords!
        .where((e) => e.status != AttendanceRecordStatus.validated)
        .map((e) {
      final DateFormat formatter = DateFormat('HH:mm');
      final idt = formatter.format(e.point.initialDate);
      var fdt = formatter.format(e.point.finalDate);
      return MultiSelectItem(e, '$idt - $fdt');
    }).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void showMultiSelect() async {
      await showModalBottomSheet(
        isScrollControlled: true, // required for min/max child size
        context: context,
        builder: (ctx) {
          return MultiSelectBottomSheet(
            items: _points,
            initialValue: _selectedPoints,
            onConfirm: (uas) => context.read<UserAttendanceValidateBloc>().add(
                  ValidatePoints(
                    attendanceRecords: uas,
                    pointRecordId: widget.pointRecordId,
                  ),
                ),
            maxChildSize: 0.8,
            title: const Text(
              'Validar pontos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            confirmText: const Text('Validar'),
            cancelText: const Text('Cancelar'),
            listType: MultiSelectListType.CHIP,
          );
        },
      );
    }

    List<AttendanceRecordModel> ars = widget.userAttendance.attendanceRecords!;
    return BlocConsumer<UserAttendanceValidateBloc,
        UserAttendanceValidateState>(
      listener: (context, state) {
        if (state is ValidationFailed) {
          return Toast.showError(state.message, context);
        }
      },
      builder: (context, state) {
        if (state is ValidationLoading) {
          return const Center(child: Spinner());
        }
        return SingleChildScrollView(
          child: GestureDetector(
            onTap: ars
                    .where(
                      (ar) => ar.status != AttendanceRecordStatus.validated,
                    )
                    .isNotEmpty
                ? showMultiSelect
                : null,
            child: Container(
              padding: const EdgeInsets.only(
                top: 10,
                right: 15,
                left: 15,
                bottom: 10,
              ),
              width: double.infinity,
              height: 60,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userAttendance.user!
                              .getFullName()
                              .toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                width: 5,
                              );
                            },
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: ars.length,
                            itemBuilder: (context, index) {
                              return AttendanceRecordIndicator(
                                attendanceRecord: ars[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
