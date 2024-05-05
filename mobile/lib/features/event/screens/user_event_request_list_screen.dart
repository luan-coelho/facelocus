import 'package:facelocus/features/event-request/blocs/user_event-request-list/user_event_request_list_bloc.dart';
import 'package:facelocus/features/event/widgets/event_request_card.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:facelocus/shared/widgets/unexpected_error.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class UserEventRequestListScreen extends StatefulWidget {
  const UserEventRequestListScreen({
    super.key,
  });

  @override
  State<UserEventRequestListScreen> createState() =>
      _UserEventRequestListScreenState();
}

class _UserEventRequestListScreenState
    extends State<UserEventRequestListScreen> {
  @override
  void initState() {
    context.read<UserEventRequestListBloc>().add(LoadAllUserEventRequest());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Solicitações',
      body: Padding(
        padding: const EdgeInsets.all(29),
        child:
            BlocConsumer<UserEventRequestListBloc, UserEventRequestListState>(
          listener: (context, state) {
            if (state is EventRequestListError) {
              Get.snackbar('Erro', state.message);
            }
          },
          builder: (context, state) {
            if (state is EventRequestListLoading) {
              return const Center(child: Spinner());
            }

            if (state is EventRequestListEmpty) {
              return const EmptyData('Nada por aqui...');
            }

            if (state is EventRequestListError) {
              return UnexpectedError(state.message);
            }

            if (state is EventRequestListLoaded) {
              return SingleChildScrollView(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: state.eventRequests.length,
                  itemBuilder: (context, index) {
                    var eventRequest = state.eventRequests[index];
                    return EventRequestCard(
                      eventRequest: eventRequest,
                      authenticatedUser: state.authenticatedUser,
                    );
                  },
                ),
              );
            }
            return Center(
              child: AppButton(
                onPressed: () => context.read<UserEventRequestListBloc>().add(
                      LoadAllUserEventRequest(),
                    ),
                text: 'Tentar novamente',
              ),
            );
          },
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white, size: 29),
      ),
    );
  }
}
