import 'package:facelocus/features/event-request/blocs/event-request-show/event_request_show_bloc.dart';
import 'package:facelocus/features/event/widgets/event_request_create_form.dart';
import 'package:facelocus/models/event_request_model.dart';
import 'package:facelocus/models/event_request_type_enum.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/information_field.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventRequestShowScreen extends StatefulWidget {
  const EventRequestShowScreen({
    super.key,
    required this.eventRequestId,
    this.requestType = EventRequestType.invitation,
  });

  final int eventRequestId;
  final EventRequestType requestType;

  @override
  State<EventRequestShowScreen> createState() => _EventRequestShowScreenState();
}

class _EventRequestShowScreenState extends State<EventRequestShowScreen> {
  @override
  void initState() {
    context.read<EventRequestShowBloc>().add(
          LoadEventRequest(widget.eventRequestId),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showDataAlert() {
      showDialog(
        context: context,
        builder: (context) {
          return const EventRequestCreateForm();
        },
      );
    }

    return AppLayout(
      appBarTitle: 'Solicitação',
      showBottomNavigationBar: false,
      body: Padding(
        padding: const EdgeInsets.all(29),
        child: BlocConsumer<EventRequestShowBloc, EventRequestShowState>(
          listener: (context, state) {
            if (state is EventRequestShowError) {
              Toast.showError(state.message, context);
            }
          },
          builder: (context, state) {
            if (state is EventRequestShowLoading) {
              return const Center(child: Spinner());
            }

            if (state is EventRequestShowLoaded) {
              EventRequestModel eventRequest = state.eventRequest;
              String fullName = eventRequest.initiatorUser.getFullName();
              String email = eventRequest.initiatorUser.email;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
/*                    UserCardER(
                      user: eventRequest.initiatorUser,
                    ),*/
                  const SizedBox(height: 25),
                  InformationField(
                      description: 'Nome Completo', value: fullName),
                  const SizedBox(height: 15),
                  InformationField(description: 'Email', value: email),
                  const SizedBox(height: 25),
                  AppButton(
                    text: 'Aceitar',
                    onPressed: () => context.read<EventRequestShowBloc>().add(
                          ApproveEventRequest(
                            eventRequestId: widget.eventRequestId,
                            requestType: widget.requestType,
                          ),
                        ),
                  ),
                  const SizedBox(height: 10),
                  AppButton(
                    text: 'Rejeitar',
                    onPressed: () => context.read<EventRequestShowBloc>().add(
                          RejectEventRequest(
                            widget.eventRequestId,
                            widget.requestType,
                          ),
                        ),
                    backgroundColor: Colors.red.shade600,
                  )
                ],
              );
            }
            return Center(
              child: AppButton(
                onPressed: () => context.read<EventRequestShowBloc>().add(
                      LoadEventRequest(widget.eventRequestId),
                    ),
                text: 'Tentar novamente',
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showDataAlert,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white, size: 29),
      ),
    );
  }
}
