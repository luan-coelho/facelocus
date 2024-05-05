import 'package:facelocus/features/event-request/blocs/event-request-show/event_request_show_bloc.dart';
import 'package:facelocus/features/event/widgets/event_request_create_form.dart';
import 'package:facelocus/features/home/widgets/er_user_card.dart';
import 'package:facelocus/models/event_request_type_enum.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/information_field.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserEventRequestShowScreen extends StatefulWidget {
  const UserEventRequestShowScreen({
    super.key,
    required this.eventRequestId,
    required this.eventId,
    this.requestType = EventRequestType.invitation,
  });

  final int eventRequestId;
  final int eventId;
  final EventRequestType requestType;

  @override
  State<UserEventRequestShowScreen> createState() =>
      _UserEventRequestShowScreenState();
}

class _UserEventRequestShowScreenState
    extends State<UserEventRequestShowScreen> {
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
              return Toast.showError(state.message, context);
            }

            if (state is RequestCompletedSuccessfully) {
              context.pop();
            }
          },
          builder: (context, state) {
            if (state is EventRequestShowLoading) {
              return const Center(child: Spinner());
            }

            if (state is EventRequestShowLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ErUserCard(
                    user: state.eventRequest.initiatorUser,
                  ),
                  const SizedBox(height: 25),
                  InformationField(
                    description: 'Nome Completo',
                    value: state.eventRequest.initiatorUser.getFullName(),
                  ),
                  const SizedBox(height: 25),
                  AppButton(
                      text: 'Aceitar',
                      onPressed: () => context
                          .read<EventRequestShowBloc>()
                          .add(ApproveEventRequest(
                            eventRequestId: widget.eventRequestId,
                            eventId: widget.eventId,
                            requestType: widget.requestType,
                          ))),
                  const SizedBox(height: 10),
                  AppButton(
                    text: 'Rejeitar',
                    onPressed: () => context
                        .read<EventRequestShowBloc>()
                        .add(RejectEventRequest(
                          eventRequestId: widget.eventRequestId,
                          eventId: widget.eventId,
                          requestType: widget.requestType,
                        )),
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
