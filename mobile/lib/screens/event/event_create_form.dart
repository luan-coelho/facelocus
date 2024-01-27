import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/event_controller.dart';

class EventCreateForm extends StatefulWidget {
  const EventCreateForm({super.key});

  @override
  State<EventCreateForm> createState() => _EventCreateFormState();
}

class _EventCreateFormState extends State<EventCreateForm> {
  late EventController _controller;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  EventModel event = EventModel.empty();
  bool allowTicketRequests = false;

  @override
  void initState() {
    _controller = Get.find<EventController>();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(29.0),
        child: Builder(builder: (context) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                    textEditingController: _descriptionController,
                    labelText: 'Descrição',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a descrição';
                      }
                      return null;
                    },
                    onSaved: (value) => event.description = value!),
                Row(
                  children: [
                    const Flexible(
                      child: Text(
                          'Permitir que outros participantes enviem solicitações para ingresso',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    Switch(
                        value: allowTicketRequests,
                        onChanged: (value) {
                          setState(() {
                            allowTicketRequests = value;
                          });
                        }),
                  ],
                ),
                const SizedBox(height: 15),
                Obx(() {
                  return AppButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          event.allowTicketRequests = allowTicketRequests;
                          _controller.create(context, event);
                        }
                      },
                      text: 'Cadastrar',
                      icon: _controller.isLoading.value
                          ? const SizedBox(
                              width: 17,
                              height: 17,
                              child: CircularProgressIndicator(
                                  color: Colors.white))
                          : null);
                })
              ],
            ),
          );
        }),
      ),
    );
  }
}
