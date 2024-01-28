import 'package:facelocus/controllers/ticket_request_controller.dart';
import 'package:facelocus/controllers/user_controller.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_search_card.dart';
import 'package:facelocus/utils/debouncer.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LinckedUsersDelegate extends SearchDelegate<UserModel> {
  late final UserController _controller;
  late final TicketRequestController _ticketRequestController;
  late final Debouncer _debouncer;

  LinckedUsersDelegate() {
    _controller = Get.find<UserController>();
    _ticketRequestController = Get.find<TicketRequestController>();
    _debouncer = Debouncer();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        textTheme: const TextTheme(titleLarge: TextStyle(fontSize: 16)),
        hintColor: Colors.white);
  }

  @override
  String get searchFieldLabel => 'Nome ou CPF';

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
      if (query.isNotEmpty && query.trim().isBlank == false) {
        _debouncer.run(() async => _controller.fetchAllByNameOrCpf(query));
      }
    });
    return buildSearchResults();
  }

  Widget buildSearchResults() {
    return Obx(
      () {
        if (_controller.isLoading.value) {
          return const Center(
            child: Spinner(
              label: 'Procurando usuários...',
            ),
          );
        }

        if (_controller.usersSearch.isEmpty) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(29.0),
            child: Text('Nenhum usuário encontrado',
                style: TextStyle(color: Colors.black)),
          ));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(15),
          itemCount: _controller.usersSearch.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 10);
          },
          itemBuilder: (BuildContext context, int index) {
            UserModel user = _controller.usersSearch[index];
            return GestureDetector(
                onTap: () => close(context, user),
                child: AppSearchCard(
                  description: user.getFullName(),
                  child: AppButton(
                    onPressed: () => Toast.success(
                        context, 'Solicitação enviada com sucesso'),
                    text: 'Enviar',
                    width: 80,
                    height: 25,
                    textFontSize: 12,
                  ),
                ));
          },
        );
      },
    );
  }
}
