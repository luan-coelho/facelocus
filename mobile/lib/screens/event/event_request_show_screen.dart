import 'package:facelocus/controllers/event_request_controller.dart';
import 'package:facelocus/models/event_request_model.dart';
import 'package:facelocus/models/event_request_type_enum.dart';
import 'package:facelocus/screens/event/widgets/event_request_create_form.dart';
import 'package:facelocus/screens/home/widgets/user_card_er.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/information_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EventRequestShowScreen extends StatefulWidget {
  const EventRequestShowScreen(
      {super.key,
      required this.eventRequestId,
      this.requestType = EventRequestType.invitation});

  final int eventRequestId;
  final EventRequestType requestType;

  @override
  State<EventRequestShowScreen> createState() => _EventRequestShowScreenState();
}

class _EventRequestShowScreenState extends State<EventRequestShowScreen> {
  late final EventRequestController _controller;

  @override
  void initState() {
    _controller = Get.find<EventRequestController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchById(widget.eventRequestId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showDataAlert() {
      showDialog(
          context: context,
          builder: (context) {
            return const EventRequestCreateForm();
          });
    }

    return AppLayout(
        appBarTitle: 'Solicitação',
        showBottomNavigationBar: false,
        body: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Obx(
            () {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              EventRequestModel eventRequest = _controller.eventRequest.value!;
              String fullName = eventRequest.initiatorUser.getFullName();
              String cpf = eventRequest.initiatorUser.cpf;
              String email = eventRequest.initiatorUser.email;
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UserCardER(
                      user: _controller.eventRequest.value!.initiatorUser,
                    ),
                    const SizedBox(height: 25),
                    InformationField(
                        description: 'Nome Completo', value: fullName),
                    const SizedBox(height: 15),
                    InformationField(description: 'Email', value: email),
                    const SizedBox(height: 25),
                    AppButton(
                        text: 'Aceitar',
                        onPressed: () {
                          _controller.approve(context, widget.eventRequestId,
                              widget.requestType);
                          context.pop();
                        }),
                    const SizedBox(height: 10),
                    AppButton(
                        text: 'Rejeitar',
                        onPressed: () => _controller.reject(
                            context, widget.eventRequestId, widget.requestType),
                        backgroundColor: Colors.red.shade600)
                  ]);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: showDataAlert,
          backgroundColor: Colors.green,
          child: const Icon(Icons.add, color: Colors.white, size: 29),
        ));
  }
}
