import 'package:facelocus/controllers/point_record_show_controller.dart';
import 'package:facelocus/screens/point-record/widgets/event_header.dart';
import 'package:facelocus/screens/point-record/widgets/point_validate.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(29.0),
                child: Obx(
                  () {
                    if (_controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(
                          builder: (context) {
                            var pr = _controller.pointRecord.value;
                            return EventHeader(
                              description: pr!.event!.description!,
                              date: pr.date,
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        Builder(
                          builder: (context) {
                            var ua = _controller.userAttendance.value;
                            if (ua == null) {
                              return const Center(
                                  child: Text('Ainda não há nenhum ponto'));
                            }

                            var ars = ua.attendanceRecords!;
                            return ListView.separated(
                              separatorBuilder: (
                                BuildContext context,
                                int index,
                              ) {
                                return const SizedBox(height: 10);
                              },
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: ars.length,
                              itemBuilder: (context, index) {
                                return PointValidate(
                                  attendanceRecord: ars[index],
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
          ],
        ),
      ),
    );
  }
}
