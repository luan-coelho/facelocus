import 'package:facelocus/features/event/blocs/event-code-card/event_code_card_bloc.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

class EventCodeCard extends StatelessWidget {
  final EventModel event;

  const EventCodeCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    void shareCode() {
      var message = 'Ingresse no evento ${event.description} - ${event.code!}';
      String subject = message;
      Share.share(event.code!, subject: subject);
    }

    return BlocListener<EventCodeCardBloc, EventCodeCardState>(
      listener: (context, state) {
        if (state is CodeCopiedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              showCloseIcon: true,
              content: Text(
                'Código ${state.code} copiado para a área de transferência',
                style: const TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
          );
        }

        if (state is EventCodeCardError) {
          return Toast.showError(state.message, context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Código para ingresso',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                const SizedBox(width: 5),
                Text(
                  event.code!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(text: event.code ?? 'Sem código'),
                    );
                    if (context.mounted) {
                      context.read<EventCodeCardBloc>().add(
                            CodeCopied(event.code!),
                          );
                    }
                  },
                  child: SvgPicture.asset(
                    'images/clipboard-copy-icon.svg',
                    width: 25,
                    colorFilter: const ColorFilter.mode(
                      Colors.green,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: () => shareCode(),
                  child: SvgPicture.asset(
                    'images/share-icon.svg',
                    width: 25,
                    colorFilter: const ColorFilter.mode(
                      Colors.green,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Você tem certeza?'),
                      content: const Text(
                        'Após confirmação, um novo código será gerado para este evento.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<EventCodeCardBloc>().add(
                                  GenerateNewCode(event.id!),
                                );
                            Navigator.pop(context, 'OK');
                          },
                          child: const Text(
                            'Confirmar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: SvgPicture.asset(
                    'images/refresh-ccw-dot-icon.svg',
                    width: 25,
                    colorFilter: const ColorFilter.mode(
                      Colors.green,
                      BlendMode.srcIn,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
