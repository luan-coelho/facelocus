import 'package:facelocus/controllers/point_record_show_controller.dart';
import 'package:facelocus/delegates/lincked_users_delegate.dart';
import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/models/user_attendace_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/point-record/widgets/attendance_record_indicator.dart';
import 'package:facelocus/screens/point-record/widgets/event_header.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

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
      _controller.fetchById(context, widget.pointRecordId);
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
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.pointRecord.value!.event!.users!.isEmpty) {
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
                description: _controller.pointRecord.value!.event!.description!,
                date: _controller.pointRecord.value!.date,
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
  });

  final UserAttendanceModel userAttendance;

  @override
  State<StatefulWidget> createState() => _ExpandingCardState();
}

class _ExpandingCardState extends State<ExpandingCard> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<AttendanceRecordModel> ars = widget.userAttendance.attendanceRecords!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 300,
      height: _isExpanded ? 100 : 60,
      curve: Curves.fastOutSlowIn,
      child: Container(
        padding: const EdgeInsets.only(
          top: 10,
          right: 15,
          left: 15,
          bottom: 10,
        ),
        width: double.infinity,
        height: 45,
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
                  const Text(
                    'Teste',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: _isExpanded ? 0 : 5,
                          height: _isExpanded ? 5 : 0,
                        );
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection:
                          _isExpanded ? Axis.vertical : Axis.horizontal,
                      itemCount: ars.length,
                      itemBuilder: (context, index) {
                        return AttendanceRecordIndicator(
                          attendanceRecord: ars[index],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: _toggleExpansion,
              child: Icon(
                size: 40,
                _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              ),
            )
          ],
        ),
      ),
    );
  }
}
