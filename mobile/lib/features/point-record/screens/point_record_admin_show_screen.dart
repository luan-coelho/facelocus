import 'package:facelocus/controllers/point_record_show_controller.dart';
import 'package:facelocus/features/event/delegates/lincked_users_delegate.dart';
import 'package:facelocus/features/point-record/widgets/attendance_record_indicator.dart';
import 'package:facelocus/features/point-record/widgets/event_header.dart';
import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/models/attendance_record_status_enum.dart';
import 'package:facelocus/models/user_attendace_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class PointRecordAdminShowScreen extends StatefulWidget {
  const PointRecordAdminShowScreen({
    super.key,
    required this.pointRecordId,
  });

  final int pointRecordId;

  @override
  State<PointRecordAdminShowScreen> createState() =>
      _PointRecordAdminShowScreenState();
}

class _PointRecordAdminShowScreenState
    extends State<PointRecordAdminShowScreen> {
  late final PointRecordShowController _controller;

  @override
  void initState() {
    _controller = Get.find<PointRecordShowController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchPointRecordById(context, widget.pointRecordId);
      _controller.fetchAllByPointRecord(context, widget.pointRecordId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Registro de ponto',
      actions: [
        IconButton(
          icon: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onPressed: () => context.push(
            '/admin${AppRoutes.pointRecordEdit}/${widget.pointRecordId}',
          ),
        )
      ],
      showBottomNavigationBar: false,
      body: Padding(
        padding: const EdgeInsets.all(29.0),
        child: Obx(() {
          if (_controller.isLoading.value || _controller.prIsLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.pointRecord.value != null &&
              _controller.pointRecord.value!.event!.users!.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const EmptyData('Sem usuários vinculados ao evento'),
                const SizedBox(height: 15),
                AppButton(
                  text: 'Enviar solicitação',
                  onPressed: () async {
                    await showSearch(
                      context: context,
                      delegate: LinckedUsersDelegate(
                        eventId: _controller.pointRecord.value!.event!.id!,
                      ),
                    );
                  },
                )
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventHeader(
                description:
                    _controller.pointRecord.value?.event?.description ?? '...',
                date: _controller.pointRecord.value?.date ?? DateTime.now(),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Builder(builder: (context) {
                      var us = _controller.uas;
                      return ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: us.length,
                        itemBuilder: (context, index) {
                          return ExpandingCard(
                            userAttendance: us[index],
                            pointRecordId: widget.pointRecordId,
                          );
                        },
                      );
                    })
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class ExpandingCard extends StatefulWidget {
  const ExpandingCard({
    super.key,
    required this.userAttendance,
    required this.pointRecordId,
  });

  final UserAttendanceModel userAttendance;
  final int pointRecordId;

  @override
  State<StatefulWidget> createState() => _ExpandingCardState();
}

class _ExpandingCardState extends State<ExpandingCard> {
  late final PointRecordShowController _controller;
  late List<MultiSelectItem<AttendanceRecordModel?>> _points;
  final List<AttendanceRecordModel?> _selectedPoints = [];

  @override
  void initState() {
    _controller = Get.find<PointRecordShowController>();

    List<MultiSelectItem<AttendanceRecordModel?>> list = widget
        .userAttendance.attendanceRecords!
        .where((e) => e.status != AttendanceRecordStatus.validated)
        .map((e) {
      final DateFormat formatter = DateFormat('HH:mm');
      final idt = formatter.format(e.point.initialDate);
      var fdt = formatter.format(e.point.finalDate);
      return MultiSelectItem(e, '$idt - $fdt');
    }).toList();
    _points = list;
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
            onConfirm: (uas) => _controller.validateUserPoints(
              context,
              uas,
              widget.pointRecordId,
            ),
            maxChildSize: 0.8,
            title: const Text('Validar pontos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
            confirmText: const Text('Validar'),
            cancelText: const Text('Cancelar'),
            listType: MultiSelectListType.CHIP,
          );
        },
      );
    }

    List<AttendanceRecordModel> ars = widget.userAttendance.attendanceRecords!;
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: ars
                .where((ar) => ar.status != AttendanceRecordStatus.validated)
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
                      widget.userAttendance.user!.getFullName(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (BuildContext context, int index) {
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
  }
}
