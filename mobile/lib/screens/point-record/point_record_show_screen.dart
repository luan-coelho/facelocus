import 'package:facelocus/controllers/point_record_show_controller.dart';
import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/models/attendance_record_status_enum.dart';
import 'package:facelocus/screens/point-record/widgets/event_header.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
        body: Padding(
          padding: const EdgeInsets.all(29.0),
          child: Obx(() {
            if (_controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EventHeader(
                    description:
                        _controller.pointRecord.value!.event!.description!,
                    date: _controller.pointRecord.value!.date),
                const SizedBox(height: 15),
                Builder(builder: (context) {
                  List<AttendanceRecordModel> attendanceRecords =
                      _controller.userAttendance.value!.attendanceRecords!;
                  return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: attendanceRecords.length,
                    itemBuilder: (context, index) {
                      return PointValidate(
                          attendanceRecord: attendanceRecords[index]);
                    },
                  );
                })
              ],
            );
          }),
        ));
  }
}

class PointValidate extends StatefulWidget {
  const PointValidate({super.key, required this.attendanceRecord});

  final AttendanceRecordModel attendanceRecord;

  @override
  State<PointValidate> createState() => _PointValidateState();
}

class _PointValidateState extends State<PointValidate> {
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
    return Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        width: double.infinity,
        height: 60,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(builder: (context) {
              final DateFormat formatter = DateFormat('HH:mm');
              final String initialDate =
                  formatter.format(widget.attendanceRecord.point.initialDate);
              final String finalDate =
                  formatter.format(widget.attendanceRecord.point.finalDate);
              return Text('$initialDate - $finalDate',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18));
            }),
            SizedBox(
              height: 45.0,
              width: 45.0,
              child: IconButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: null,
                icon: Icon(
                    attendanceRecordStatus[widget.attendanceRecord.status],
                    size: 35.0),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      attendanceRecordColor[widget.attendanceRecord.status]!),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
              ),
            )
          ],
        )));
  }
}
