import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String description;

  const EventCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        width: 330,
        height: 45,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 1.5),
          ),
        ], borderRadius: BorderRadius.circular(8), color: Colors.white),
        child: Center(
            child: Row(
          children: [
            Text(description,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton(
                  icon: const Icon(Icons.more_vert), // Ícone de três pontos
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry>[
                      PopupMenuItem(
                        child: const Text('Editar'),
                        onTap: () {
                          // Ação a ser realizada quando a Opção 1 for selecionada
                          // Pode ser uma função ou um Navigator para outra tela
                        },
                      ),
                      PopupMenuItem(
                          child: const Text('Deletar'),
                          onTap: () {
                            // Ação a ser realizada quando a Opção 2 for selecionada
                          })
                    ];
                  }),
            )
          ],
        )));
  }
}
