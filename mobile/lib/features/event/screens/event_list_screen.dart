import 'package:facelocus/features/event/blocs/event-list/event_list_bloc.dart';
import 'package:facelocus/features/event/screens/event_create_form.dart';
import 'package:facelocus/features/event/widgets/event_card.dart';
import 'package:facelocus/features/event/widgets/event_request_create_form.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  void initState() {
    context.read<EventListBloc>().add(LoadEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showEventCreateForm() {
      showModalBottomSheet<void>(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: const EventCreateForm(),
          );
        },
      );
    }

    showEventRequestCreateForm() {
      showModalBottomSheet<void>(
        isScrollControlled: true,
        isDismissible: true,
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: const EventRequestCreateForm(),
          );
        },
      );
    }

    Widget actions() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AppButton(
              onPressed: showEventRequestCreateForm,
              textColor: Colors.black,
              backgroundColor: Colors.white,
              borderColor: Colors.black.withOpacity(0.5),
              text: 'Ingressar-se',
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: AppButton(
              onPressed: showEventCreateForm,
              text: 'Criar evento',
            ),
          )
        ],
      );
    }

    return AppLayout(
      appBarTitle: 'Meus eventos',
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: BlocBuilder<EventListBloc, EventListState>(
          builder: (context, state) {
            if (state is EventsLoaded) {
              return Column(
                children: [
                  actions(),
                  const SizedBox(height: 20),
                  ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: state.events.length,
                    itemBuilder: (context, index) {
                      EventModel event = state.events[index];
                      return EventCard(event: event);
                    },
                  ),
                ],
              );
            }

            if (state is EventsEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const EmptyData('Você ainda não criou nenhum evento'),
                  const SizedBox(height: 25),
                  actions(),
                ],
              );
            }
            return const Center(child: Spinner());
          },
        ),
      ),
    );
  }
}
