import 'package:facelocus/features/event/blocs/event-request-list/event_request_list_bloc.dart';
import 'package:facelocus/features/event/widgets/event_request_card.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:facelocus/shared/widgets/unexpected_error.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../models/event_request_model.dart';

class EventRequestListScreen extends StatefulWidget {
  const EventRequestListScreen({
    super.key,
    required this.eventId,
  });

  final int eventId;

  @override
  State<EventRequestListScreen> createState() => _EventRequestListScreenState();
}

class _EventRequestListScreenState extends State<EventRequestListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<EventRequestModel> _filteredEventRequests = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterEventRequests);
    context.read<EventRequestListBloc>().add(LoadAllEventRequest(
          eventId: widget.eventId,
        ));
  }

  void _filterEventRequests() {
    final state = context.read<EventRequestListBloc>().state;
    if (state is EventRequestListLoaded) {
      setState(() {
        _filteredEventRequests = state.eventRequests
            .where((eventRequest) => eventRequest.initiatorUser
                .getFullName()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Solicitações',
      body: Padding(
        padding: const EdgeInsets.all(29),
        child: BlocConsumer<EventRequestListBloc, EventRequestListState>(
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
              // Inicialize _filteredEventRequests com todas as solicitações na primeira vez
              if (_filteredEventRequests.isEmpty &&
                  _searchController.text.isEmpty) {
                _filteredEventRequests = state.eventRequests;
              }
              return SingleChildScrollView(
                child: Expanded(
                  child: Column(
                    children: [
                      AppTextField(
                        textEditingController: _searchController,
                        labelText: 'Pesquisar por nome',
                      ),
                      const SizedBox(height: 20),
                      ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _filteredEventRequests.length,
                        itemBuilder: (context, index) {
                          var eventRequest = _filteredEventRequests[index];
                          return EventRequestCard(
                            eventRequest: eventRequest,
                            authenticatedUser: state.authenticatedUser,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: AppButton(
                onPressed: () => context.read<EventRequestListBloc>().add(
                      LoadAllEventRequest(
                        eventId: widget.eventId,
                      ),
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
