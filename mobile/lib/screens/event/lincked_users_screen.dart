import 'package:facelocus/controllers/user_controller.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/event/widgets/users_search.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

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
                // AppButton(
                //   text: 'Selecionar evento',
                //   onPressed: () async {
                //     await showSearch(
                //       context: context,
                //       delegate: CustomSearchDelegate(),
                //     );
                //   },
                // ),
                /*
                FeatureCard(
                    description: 'Solicitações',
                    route: Uri(
                            path: AppRoutes.eventTicketsRequest,
                            queryParameters: {'event': widget.eventId.toString()})
                        .toString(),
                    color: Colors.black,
                    backgroundColor: AppColorsConst.white,
                    imageName: 'ticket-request-icon.svg',
                    height: 130,
                    expanded: false),
                const SizedBox(height: 35),*/
                Obx(() {
                  if (_controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_controller.users.isEmpty) {
                    return Center(
                      child: EmptyData('Sem usuários vinculados',
                          child: AppButton(
                              text: 'Adicionar',
                              onPressed: () =>
                                  context.push(AppRoutes.userSearch))),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UsersSearch(widget.eventId,
                          textEditingController: _textEditingController),
                      /*AppSearchField(
                          textEditingController: _textEditingController,
                          itens: _controller.usersSearch,
                          function: () => _controller
                              .fetchAllByNameOrCpf(_textEditingController.text),
                          isLoading: _controller.isLoading.value),*/
                      const SizedBox(height: 10),
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
                      ),
                      /*const SizedBox(height: 10),
                      ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 20);
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _controller.usersSearch.length,
                        itemBuilder: (context, index) {
                          UserModel user = _controller.usersSearch[index];
                          return UserCard(user: user);
                        },
                      ),*/
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
