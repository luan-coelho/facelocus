import 'package:facelocus/features/event/blocs/event-create/event_create_bloc.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EventCreateForm extends StatefulWidget {
  const EventCreateForm({super.key});

  @override
  State<EventCreateForm> createState() => _EventCreateFormState();
}

class _EventCreateFormState extends State<EventCreateForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(29.0),
        child: Form(
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
              ),
              Row(
                children: [
                  const Flexible(
                    child: Text(
                      'Permitir que outros participantes enviem solicitações para ingresso',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
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
              BlocConsumer<EventCreateBloc, EventCreateState>(
                listener: (context, state) {
                  if (state is EventCreateSuccess) {
                    context.pop();
                    context.push('${AppRoutes.eventShow}/${state.eventId}');
                  }

                  if (state is EventCreateError) {
                    return Toast.showError(
                      title: 'Erro de validação',
                      state.message,
                      context,
                    );
                  }
                },
                builder: (context, state) {
                  return AppButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<EventCreateBloc>().add(
                                EventCreate(
                                  description: _descriptionController.text,
                                  allowTicketRequests: allowTicketRequests,
                                ),
                              );
                        }
                      },
                      text: 'Cadastrar',
                      icon: state is EventCreateLoading
                          ? const SizedBox(
                              width: 17,
                              height: 17,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : null);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
