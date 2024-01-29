import 'package:facelocus/controllers/user_controller.dart';
import 'package:facelocus/delegates/lincked_users_delegate.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/screens/event/widgets/lincked_user_card.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LinckedUsersScreen extends StatefulWidget {
  const LinckedUsersScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<LinckedUsersScreen> createState() => _LinckedUsersScreenState();
}

class _LinckedUsersScreenState extends State<LinckedUsersScreen> {
  late final UserController _controller;

  @override
  void initState() {
    _controller = Get.find<UserController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchAllByEventId(widget.eventId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Usuários vinculados',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(29.0),
          child: Column(
            children: [
              AppButton(
                text: 'Enviar solicitação',
                onPressed: () async {
                  await showSearch(
                    context: context,
                    delegate: LinckedUsersDelegate(eventId: widget.eventId),
                  );
                },
              ),
              const SizedBox(height: 15),
              Obx(() {
                if (_controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_controller.users.isEmpty) {
                  return const Center(
                    child: EmptyData('Sem usuários vinculados'),
                  );
                }
                return Column(
                  children: [
                    Obx(() {
                      return Skeletonizer(
                        enabled: _controller.isLoading.value,
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 10);
                          },
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _controller.users.length,
                          itemBuilder: (context, index) {
                            UserModel user = _controller.users[index];
                            return LinckedUserCard(user: user);
                          },
                        ),
                      );
                    }),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
