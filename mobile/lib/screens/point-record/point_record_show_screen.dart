import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:facelocus/utils/expansion_panel_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
                                            overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                                subtitle: Row(children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    width: 15.0,
                                    height: 15.0,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: Colors.black)),
                                  ),
                                  Row(children: [
                                    Container(
                                      width: 15.0,
                                      height: 15.0,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.black)),
                                    )
                                  ]),
                                  Row(children: [
                                    Container(
                                      width: 15.0,
                                      height: 15.0,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.black)),
                                    )
                                  ]),
                                  Row(children: [
                                    Container(
                                      width: 15.0,
                                      height: 15.0,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.black)),
                                    )
                                  ])
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
              );
            }),
          ),
        ));
  }
}
