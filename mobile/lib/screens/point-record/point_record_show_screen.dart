import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/screens/point-record/widgets/attendance_record_indicator.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:facelocus/utils/expansion_panel_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PointRecordShowScreen extends StatefulWidget {
  const PointRecordShowScreen({super.key, required this.pointRecordId});

  final int pointRecordId;

  @override
  State<PointRecordShowScreen> createState() => _PointRecordShowScreenState();
}

class _PointRecordShowScreenState extends State<PointRecordShowScreen> {
  late final PointRecordController _controller;

  @override
  void initState() {
    _controller = Get.find<PointRecordController>();
    _controller.fetchById(context, widget.pointRecordId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
        appBarTitle: 'Registro de ponto',
        showBottomNavigationBar: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(29.0),
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_controller.pointRecord.value!.event!.users!.isEmpty) {
                return const Center(
                  child: EmptyData('Sem usuários vinculados'),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_controller.pointRecord.value!.event!.description!,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis)),
                      const SizedBox(height: 10),
                      Builder(builder: (context) {
                        DateTime date = _controller.pointRecord.value!.date;
                        String datef = DateFormat('dd/MM/yyyy').format(date);
                        return Container(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: const BoxDecoration(
                              color: Colors.amber,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(datef,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                        );
                      })
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Obx(() {
                        return Skeletonizer(
                          enabled: _controller.isLoading.value,
                          child: ExpansionPanelList(
                            expandedHeaderPadding: const EdgeInsets.all(0),
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                _controller.panelItems[index].isExpanded =
                                    isExpanded;
                              });
                            },
                            children: _controller.panelItems
                                .map<ExpansionPanel>((Item<UserModel> item) {
                              return ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    iconColor: Colors.blue,
                                    title: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'images/user-icon.svg',
                                          width: 25,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(item.content!.getFullName(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                      ],
                                    ),
                                    subtitle: const Row(children: [
                                      SizedBox(width: 30),
                                      AttendanceRecordIndicator(),
                                      SizedBox(width: 5),
                                      AttendanceRecordIndicator(),
                                      SizedBox(width: 5),
                                      AttendanceRecordIndicator(),
                                      SizedBox(width: 5),
                                      AttendanceRecordIndicator(),
                                    ]),
                                  );
                                },
                                body: ListTile(
                                    title: Text(item.content!.getFullName(),
                                        style: const TextStyle(fontSize: 12)),
                                    subtitle: const Text(
                                        'To delete this panel, tap the trash can icon'),
                                    trailing: const Icon(Icons.delete),
                                    onTap: () {
                                      setState(() {});
                                    }),
                                isExpanded: item.isExpanded,
                              );
                            }).toList(),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              );
            }),
          ),
        ));
  }
}
