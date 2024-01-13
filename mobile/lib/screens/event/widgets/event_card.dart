import 'package:facelocus/models/event.dart';
import 'package:facelocus/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('${AppRoutes.eventShow}/${event.id}'),
      child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          width: 330,
          height: 45,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(event.description!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis)),
              ),
              PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  // Ícone de três pontos
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry>[
                      PopupMenuItem(
                        child: const Text('Editar'),
                        onTap: () {},
                      ),
                      PopupMenuItem(child: const Text('Deletar'), onTap: () {})
                    ];
                  })
            ],
          )),
    );
  }
}
