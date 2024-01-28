import 'package:facelocus/controllers/event_controller.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_search_card.dart';
import 'package:facelocus/utils/debouncer.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventDelegate extends SearchDelegate<EventModel> {
  late final EventController _controller;

  // late final AuthController _authController;
  late final Debouncer _debouncer;

  EventDelegate() {
    _controller = Get.find<EventController>();
    // _authController = Get.find<AuthController>();
    _debouncer = Debouncer();
    // UserModel user = _authController.authenticatedUser.value!;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _debouncer
          .run(() async => _controller.fetchAllByDescription(context, query));
    });
    return buildSearchResults();
  }

  Widget buildSearchResults() {
    return Obx(
      () {
        if (_controller.isLoading.value) {
          return const Center(
            child: Spinner(
              label: 'Procurando eventos...',
            ),
          );
        }

        if (_controller.events.isEmpty) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(29.0),
            child: Text('Nenhum evento encontrado',
                style: TextStyle(color: Colors.black)),
          ));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(15),
          itemCount: _controller.events.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 10);
          },
          itemBuilder: (BuildContext context, int index) {
            EventModel event = _controller.events[index];
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
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColorsConst.blue),
                        ),
                      ),
                    )));
          },
        );
      },
    );
  }
}
