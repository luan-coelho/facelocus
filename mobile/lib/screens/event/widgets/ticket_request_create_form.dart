import 'package:facelocus/controllers/ticket_request_controller.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketRequestCreateForm extends StatefulWidget {
  const TicketRequestCreateForm({super.key});

  @override
  State<TicketRequestCreateForm> createState() =>
      _TicketRequestCreateFormState();
}

class _TicketRequestCreateFormState extends State<TicketRequestCreateForm> {
  late TicketRequestController _controller;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;

  @override
  void initState() {
    _controller = Get.find<TicketRequestController>();
    _codeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void request() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
        _controller.createByCode(context, _codeController.text);
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(29.0),
        child: Builder(builder: (context) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                    textEditingController: _codeController,
                    labelText: 'Código',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o código';
                      }

                      if ((value as String).length != 6) {
                        return 'O código deve ter 6 dígitos';
                      }
                      return null;
                    },
                    maxLength: 6),
                const SizedBox(height: 10),
                Obx(() {
                  return AppButton(
                      onPressed: request,
                      text: 'Solicitar',
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
