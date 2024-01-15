import 'package:facelocus/controllers/event_controller.dart';
import 'package:facelocus/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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

    generateNewCode() {
      var controller = Get.find<EventController>();
      controller.generateNewCode(event.id!);
      Navigator.pop(context, "Cancel");
    }

    return Container(
        padding:
            const EdgeInsets.all(15),
        width: 330,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 5,
                offset: const Offset(0, 1.5),
              ),
            ],
            color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Código para ingresso',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                  const SizedBox(width: 5),
                  Text(event.code!,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                ]),
            Row(
              children: [
                GestureDetector(
                  onTap: () async => await Clipboard.setData(
                      ClipboardData(text: event.code ?? 'Sem código')),
                  child: SvgPicture.asset(
                    'images/clipboard-copy-icon.svg',
                    width: 20,
                    colorFilter:
                        const ColorFilter.mode(Colors.green, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => shareCode(),
                  child: SvgPicture.asset(
                    'images/share-icon.svg',
                    width: 20,
                    colorFilter:
                        const ColorFilter.mode(Colors.green, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("Você tem certeza?"),
                      content: const Text(
                          'Após confirmação, um novo código será gerado para este evento.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, "Cancel"),
                          child: const Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () => generateNewCode(),
                          child: const Text("Confirmar",
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                  child: SvgPicture.asset(
                    'images/refresh-ccw-dot-icon.svg',
                    width: 20,
                    colorFilter:
                        const ColorFilter.mode(Colors.green, BlendMode.srcIn),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
