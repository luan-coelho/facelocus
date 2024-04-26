import 'package:facelocus/features/event/blocs/event-request-create/event_request_create_bloc.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EventRequestCreateForm extends StatefulWidget {
  const EventRequestCreateForm({super.key});

  @override
  State<EventRequestCreateForm> createState() => _EventRequestCreateFormState();
}

class _EventRequestCreateFormState extends State<EventRequestCreateForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(29.0),
        child: Builder(
          builder: (context) {
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
                    maxLength: 6,
                  ),
                  const SizedBox(height: 10),
                  BlocConsumer<EventRequestCreateBloc, EventRequestCreateState>(
                    listener: (context, state) {
                      if (state is TicketRequestCreateSuccess) {
                        Toast.showSuccess(
                          'Solicitação de ingresso enviada com sucesso',
                          context,
                        );
                        context.pop();
                      }
                    },
                    builder: (context, state) {
                      return AppButton(
                        isLoading: state is TicketRequestCreateLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<EventRequestCreateBloc>().add(
                                  CreateTicketRequest(
                                    code: _codeController.text,
                                  ),
                                );
                          }
                        },
                        text: 'Solicitar',
                      );
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
