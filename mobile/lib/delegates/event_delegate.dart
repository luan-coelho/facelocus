import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/event_service.dart';
import 'package:facelocus/shared/widgets/app_search_card.dart';
import 'package:facelocus/utils/debouncer.dart';
import 'package:facelocus/utils/paged.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventDelegate extends SearchDelegate<EventModel> {
  late Paged<EventModel> searchedEvents;
  final ScrollController _scrollController = ScrollController();
  final _debounce = Debouncer();
  final EventService _service = EventService();
  late AuthController _authController;

  EventDelegate() {
    _authController = Get.find<AuthController>();
    UserModel user = _authController.authenticatedUser.value!;
    searchedEvents = Paged(
        expectedPageSize: 0,
        load: (page) => _service.getAllByDescription(user.id!, query));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent * .9) {
        searchedEvents.next();
      }
    });
  }

  @override
  List<Widget> buildActions(BuildContext context) => [];

  @override
  Widget buildLeading(BuildContext context) => const BackButton();

  @override
  Widget buildResults(BuildContext context) => content(query);

  @override
  Widget buildSuggestions(BuildContext context) {
    _debounce.run(() async => searchedEvents.reload());
    return content(query);
  }

  // if (searchedCountries.loadingMore) const Spinner(),

  content(query) {
    return StreamBuilder(
      stream: searchedEvents.notifier.stream,
      builder: (context, snapshot) {
        return Column(
          children: [
            Builder(builder: (context) {
              if (searchedEvents.loadingInitial) {
                return const Spinner(
                  label: 'Procurando eventos...',
                );
              }

              if (searchedEvents.items.isEmpty) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(29.0),
                  child: Text('Nenhum evento encontrado'),
                ));
              }

              return Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(10),
                  controller: _scrollController,
                  itemCount: searchedEvents.items.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    EventModel event = searchedEvents.items[index];
                    return GestureDetector(
                        onTap: () => close(context, event),
                        child: AppSearchCard(description: event.description!));
                  },
                ),
              );
            })
          ],
        );
      },
    );
  }
}
