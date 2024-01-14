import 'package:facelocus/models/event.dart';
import 'package:facelocus/providers/event_provider.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventCreateForm extends StatefulWidget {
  const EventCreateForm({super.key});

  @override
  State<EventCreateForm> createState() => _EventCreateFormState();
}

class _EventCreateFormState extends State<EventCreateForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  EventModel event = EventModel.empty();
  bool allowTicketRequests = false;

  @override
  void initState() {
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
    return AlertDialog(
      scrollable: true,
      title: const Text('Novo evento'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
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
                const SizedBox(height: 15),
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
              ],
            ),
          );
        }),
      ),
      actions: [
        Consumer<EventProvider>(builder: (context, state, child) {
          return AppButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                  event.allowTicketRequests = allowTicketRequests;
                  state.create(context, event);
                }
              },
              text: 'Cadastrar',
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
