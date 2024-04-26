import 'package:facelocus/delegates/lincked_users_delegate.dart';
import 'package:facelocus/features/event/blocs/lincked-users/lincked_users_bloc.dart';
import 'package:facelocus/features/event/widgets/lincked_user_card.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:facelocus/shared/widgets/unexpected_error.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LinckedUsersScreen extends StatefulWidget {
  const LinckedUsersScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<LinckedUsersScreen> createState() => _LinckedUsersScreenState();
}

class _LinckedUsersScreenState extends State<LinckedUsersScreen> {
  @override
  void initState() {
    context.read<LinckedUsersBloc>().add(
          LoadLinckedUsers(
            eventId: widget.eventId,
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Usuários vinculados',
      body: Padding(
        padding: const EdgeInsets.all(29.0),
        child: BlocBuilder<LinckedUsersBloc, LinckedUsersState>(
          builder: (context, state) {
            if (state is LinckedUsersEmpty) {
              return Center(
                child: EmptyData(
                  'Sem usuários vinculados',
                  child: AppButton(
                    text: 'Enviar solicitação',
                    onPressed: () async {
                      await showSearch(
                        context: context,
                        delegate: LinckedUsersDelegate(eventId: widget.eventId),
                      );
                    },
                  ),
                ),
              );
            }

            if (state is LinckedUsersError) {
              return UnexpectedError(
                state.message,
                child: AppButton(
                  text: 'Tentar novamente',
                  onPressed: () {
                    context.read<LinckedUsersBloc>().add(
                          LoadLinckedUsers(
                            eventId: widget.eventId,
                          ),
                        );
                  },
                ),
              );
            }

            if (state is LinckedUsersLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.separated(
                      separatorBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        return const SizedBox(height: 10);
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        UserModel user = state.users[index];
                        return LinckedUserCard(
                          user: user,
                          eventId: widget.eventId,
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Spinner());
          },
        ),
      ),
    );
  }
}
