import 'package:facelocus/features/event/blocs/lincked-user/lincked_user_bloc.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_delete_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class LinckedUserCard extends StatefulWidget {
  const LinckedUserCard({
    super.key,
    required this.user,
    required this.eventId,
  });

  final UserModel user;
  final int eventId;

  @override
  State<LinckedUserCard> createState() => _LinckedUserCardState();
}

class _LinckedUserCardState extends State<LinckedUserCard> {
  @override
  Widget build(BuildContext context) {
    showDeleteDialog() {
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Você tem certeza?'),
          content: const Text(
            'Tem certeza de que deseja remover este usuário deste evento?'
            'Ele será desvinculado de cada registro de ponto.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => context.read<LinckedUserBloc>().add(
                    RemoveUser(
                      eventId: widget.eventId,
                      userId: widget.user.id!,
                    ),
                  ),
              child: const Text(
                'Confirmar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<LinckedUserBloc, LinckedUserState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: null,
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            width: double.infinity,
            height: 45,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'images/user-icon.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColorsConst.black,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.user.getFullName(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                AppDeleteButton(
                  onPressed: showDeleteDialog,
                  isLoading: state is LinckedUserLoading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
