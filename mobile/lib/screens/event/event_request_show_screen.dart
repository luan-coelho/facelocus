import 'package:facelocus/controllers/event_request_controller.dart';
import 'package:facelocus/screens/event/widgets/event_request_create_form.dart';
import 'package:facelocus/screens/profile/widgets/user_face_image.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/information_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EventRequestShowScreen extends StatefulWidget {
  const EventRequestShowScreen({super.key, required this.eventRequestId});

  final int eventRequestId;

  @override
  State<EventRequestShowScreen> createState() => _EventRequestShowScreenState();
}

class _EventRequestShowScreenState extends State<EventRequestShowScreen> {
  late final EventRequestController _controller;

  @override
  void initState() {
    _controller = Get.find<EventRequestController>();
    _controller.fetchById(widget.eventRequestId);
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
        body: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Obx(
            () {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              String fullName =
                  _controller.eventRequest.requestOwner.getFullName();
              String cpf = _controller.eventRequest.requestOwner.cpf;
              String email = _controller.eventRequest.requestOwner.email;
              return Padding(
                  padding: const EdgeInsets.all(29),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const UserFaceImage(),
                        const SizedBox(height: 25),
                        InformationField(
                            description: 'Nome Completo', value: fullName),
                        const SizedBox(height: 15),
                        InformationField(description: 'CPF', value: cpf),
                        const SizedBox(height: 15),
                        InformationField(description: 'Email', value: email),
                        const SizedBox(height: 25),
                        AppButton(
                            text: 'Aceitar',
                            onPressed: () {
                              _controller.approve(
                                  context, widget.eventRequestId);
                              context.pop();
                            }),
                        const SizedBox(height: 10),
                        AppButton(
                            text: 'Rejeitar',
                            onPressed: () => _controller.reject(
                                context, widget.eventRequestId),
                            backgroundColor: Colors.red.shade600)
                      ]));
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
