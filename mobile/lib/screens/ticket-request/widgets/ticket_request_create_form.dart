import 'package:facelocus/providers/ticket_request_provider.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketRequestCreateForm extends StatefulWidget {
  const TicketRequestCreateForm({super.key});

  @override
  State<TicketRequestCreateForm> createState() =>
      _TicketRequestCreateFormState();
}

class _TicketRequestCreateFormState extends State<TicketRequestCreateForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  bool allowTicketRequests = false;

  @override
  void initState() {
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
    return AlertDialog(
      scrollable: true,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
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
              ],
            ),
          );
        }),
      ),
      actions: [
        Consumer<TicketRequestProvider>(builder: (context, state, child) {
          return AppButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                  state.createByCode(context, _codeController.text);
                }
              },
              text: 'Solicitar',
              icon: state.isLoading
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(color: Colors.white))
                  : null);
        })
      ],
    );
  }
}
