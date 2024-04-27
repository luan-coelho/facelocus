import 'package:facelocus/features/point-record/blocs/event-delegate/event_delegate_bloc.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_search_card.dart';
import 'package:facelocus/utils/debouncer.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDelegate extends SearchDelegate<EventModel> {
  late final Debouncer _debouncer;

  EventDelegate() {
    _debouncer = Debouncer();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        textTheme: const TextTheme(titleLarge: TextStyle(fontSize: 16)),
        hintColor: Colors.white);
  }

  @override
  String get searchFieldLabel => 'Descrição';

  @override
  List<Widget> buildActions(BuildContext context) => [];

  @override
  Widget buildLeading(BuildContext context) => const BackButton();

  @override
  Widget buildResults(BuildContext context) => buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const SizedBox();
    }
    _debouncer.run(() async {
      context.read<EventDelegateBloc>().add(LoadAllEvents(description: query));
    });
    return buildSearchResults();
  }

  Widget buildSearchResults() {
    return BlocBuilder<EventDelegateBloc, EventDelegateState>(
      builder: (context, state) {
        if (state is EventDelegateLoaded) {
          return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: state.events.length,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 10);
            },
            itemBuilder: (BuildContext context, int index) {
              EventModel event = state.events[index];
              return GestureDetector(
                onTap: () => close(context, event),
                child: AppSearchCard(
                  description: event.description!,
                  child: SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      onPressed: null,
                      icon: const Icon(Icons.check, size: 18.0),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          AppColorsConst.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        if (state is EventDelegateError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(29.0),
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          );
        }

        if (state is EventDelegateEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(29.0),
              child: Text(
                'Nenhum evento encontrado',
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        }

        return const Center(
          child: Spinner(),
        );
      },
    );
  }
}
