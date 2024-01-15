import 'package:facelocus/controllers/ticket_request_controller.dart';
import 'package:facelocus/screens/event/widgets/ticket_request_create_form.dart';
import 'package:facelocus/screens/profile/widgets/user_face_image.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/information_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class TicketRequestShowScreen extends StatefulWidget {
  const TicketRequestShowScreen({super.key, required this.ticketRequestId});

  final int ticketRequestId;

  @override
  State<TicketRequestShowScreen> createState() =>
      _TicketRequestShowScreenState();
}

class _TicketRequestShowScreenState extends State<TicketRequestShowScreen> {
  late final TicketRequestController _controller;

  @override
  void initState() {
    _controller = Get.find<TicketRequestController>();
    _controller.fetchById(widget.ticketRequestId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showDataAlert() {
      showDialog(
          context: context,
          builder: (context) {
            return const TicketRequestCreateForm();
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
              String fullName = _controller.ticketRequest.user.getFullName();
              String cpf = _controller.ticketRequest.user.cpf;
              String email = _controller.ticketRequest.user.email;
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
                                  context, widget.ticketRequestId);
                              context.pop();
                            }),
                        const SizedBox(height: 10),
                        AppButton(
                            text: 'Rejeitar',
                            onPressed: () => _controller.reject(
                                context, widget.ticketRequestId),
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
