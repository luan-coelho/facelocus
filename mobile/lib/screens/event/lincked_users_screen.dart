import 'package:facelocus/controllers/user_controller.dart';
import 'package:facelocus/delegates/lincked_users_delegate.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LinckedUsersScreen extends StatefulWidget {
  const LinckedUsersScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<LinckedUsersScreen> createState() => _LinckedUsersScreenState();
}

class _LinckedUsersScreenState extends State<LinckedUsersScreen> {
  late final UserController _controller;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(29.0),
            child: Column(
              children: [
                Obx(() {
                  if (_controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_controller.users.isEmpty) {
                    return Center(
                      child: EmptyData('Sem usuários vinculados',
                          child: AppButton(
                            text: 'Enviar solicitação',
                            onPressed: () async {
                              await showSearch(
                                context: context,
                                delegate: LinckedUsersDelegate(),
                              );
                            },
                          )),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'images/users-icon.svg',
                            width: 20,
                            colorFilter: const ColorFilter.mode(
                                Colors.black, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 5),
                          const Text('Usuários',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      )
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
