import 'package:facelocus/controllers/point_record_create_controller.dart';
import 'package:facelocus/delegates/lincked_users_delegate.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/point-record/widgets/attendance_record_indicator.dart';
import 'package:facelocus/screens/point-record/widgets/event_header.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  late final PointRecordCreateController _controller;

  @override
  void initState() {
    _controller = Get.find<PointRecordCreateController>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _controller.fetchById(context, widget.pointRecordId),
    );
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
                    Skeletonizer(
                      enabled: _controller.isLoading.value,
                      child: Builder(builder: (context) {
                        var us = _controller.pointRecord.value!.event!.users;
                        return ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 10);
                          },
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: us!.length,
                          itemBuilder: (context, index) {
                            UserModel user = us[index];
                            return ExpandingCard(
                              points: _controller.pointRecord.value!.points,
                            );
                          },
                        );
                      }),
                    )
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
    required this.points,
  });

  final List<PointModel> points;

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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 300,
      height: _isExpanded ? 100 : 80,
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
                mainAxisAlignment: _isExpanded
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Teste',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Builder(builder: (context) {
                    var points = widget.points;
                    List<Widget> list = [];
                    for (var i = 0; i < points.length; i++) {
                      list.add(AttendanceRecordIndicator(point: points[i]));
                      // Último da lista
                      if (points.indexOf(points.last) != i) {
                        list.add(const SizedBox(width: 5));
                      }
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 30),
                        ...list,
                      ],
                    );
                  })
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
