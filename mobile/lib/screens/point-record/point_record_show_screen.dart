import 'package:facelocus/controllers/point_record_show_controller.dart';
import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/models/attendance_record_status_enum.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/screens/point-record/widgets/event_header.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class PointRecordShowScreen extends StatefulWidget {
  const PointRecordShowScreen({super.key, required this.pointRecordId});

  final int pointRecordId;

  @override
  State<PointRecordShowScreen> createState() => _PointRecordShowScreenState();
}

class _PointRecordShowScreenState extends State<PointRecordShowScreen> {
  late final PointRecordShowController _controller;

  @override
  void initState() {
    _controller = Get.find<PointRecordShowController>();
    _controller.fetchPointRecordById(context, widget.pointRecordId);
    _controller.fetchById(context, widget.pointRecordId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
        appBarTitle: 'Registro de ponto',
        showBottomNavigationBar: false,
        body: RefreshIndicator(
            onRefresh: () async {
              _controller.fetchById(context, widget.pointRecordId);
            },
            child: CustomScrollView(slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(29.0),
                  child: Obx(
                    () {
                      if (_controller.isLoading.value) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(builder: (context) {
                            var pr = _controller.pointRecord.value;
                            return EventHeader(
                              description: pr!.id!.toString(),
                              date: pr.date,
                            );
                          }),
                          const SizedBox(height: 15),
                          Builder(
                            builder: (context) {
                              var userAttendance =
                                  _controller.userAttendance.value;
                              if (userAttendance == null) {
                                return const Center(
                                    child: Text('Ainda não há nenhum ponto'));
                              }

                              var attendanceRecords =
                                  userAttendance.attendanceRecords!;
                              return ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(height: 10);
                                },
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: attendanceRecords.length,
                                itemBuilder: (context, index) {
                                  return PointValidate(
                                    attendanceRecord:
                                        attendanceRecords[index],
                                  );
                                },
                              );
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ])));
  }
}

class PointValidate extends StatefulWidget {
  const PointValidate({super.key, required this.attendanceRecord});

  final AttendanceRecordModel attendanceRecord;

  @override
  State<PointValidate> createState() => _PointValidateState();
}

class _PointValidateState extends State<PointValidate> {
  late final PointRecordShowController _controller;
  bool fitForValidation = false;

  final Map<AttendanceRecordStatus, IconData> attendanceRecordStatus = {
    AttendanceRecordStatus.validated: Icons.check_circle,
    AttendanceRecordStatus.notValidated: Icons.running_with_errors,
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
        border: checkIfFitForValidation()
            ? Border.all(color: Colors.amber, width: 2)
            : null,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
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
          ],
        ),
      ),
    );
  }
}
