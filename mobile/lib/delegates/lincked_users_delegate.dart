import 'package:facelocus/delegates/blocs/lincked-users-delegate/lincked_users_delegate_bloc.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_search_card.dart';
import 'package:facelocus/utils/debouncer.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class LinckedUsersDelegate extends SearchDelegate<UserModel> {
  late final Debouncer _debouncer;
  late final int eventId;

  LinckedUsersDelegate({required this.eventId}) {
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
    if (query.isNotEmpty && query.trim().isBlank == false) {
      _debouncer.run(
        () async {
          context.read<LinckedUsersDelegateBloc>().add(
                LoadAllUsers(
                  query: query,
                  eventId: eventId,
                ),
              );
        },
      );
    }
    return buildSearchResults();
  }

  Widget buildSearchResults() {
    return BlocConsumer<LinckedUsersDelegateBloc, LinckedUsersDelegateState>(
      listener: (context, state) {
        if (state is CreateInvitationSuccess) {
          Toast.showSuccess('Convite enviado com sucesso', context);
        }

        if (state is LinckedUsersError) {
          Toast.showError(state.message, context);
        }
      },
      builder: (context, state) {
        if (state is LinckedUsersLoaded) {
          return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: state.users.length,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 10);
            },
            itemBuilder: (BuildContext context, int index) {
              UserModel user = state.users[index];
              return GestureDetector(
                onTap: () => close(context, user),
                child: AppSearchCard(
                  description: user.getFullName(),
                  child: AppButton(
                    onPressed: () {
                      context.read<LinckedUsersDelegateBloc>().add(
                            CreateEnviation(
                              eventId: eventId,
                              userId: user.id!,
                            ),
                          );
                    },
                    text: 'Enviar',
                    width: 80,
                    height: 25,
                    textFontSize: 12,
                  ),
                ),
              );
            },
          );
        }

        if (state is LinckedUsersError) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(29.0),
              child: Text(
                'Erro ao buscar usuários',
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        }

        if (state is LinckedUsersEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(29.0),
              child: Text(
                'Nenhum usuário encontrado',
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
