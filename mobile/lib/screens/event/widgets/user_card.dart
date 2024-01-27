import 'package:dio/dio.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  const UserCard({super.key, required this.user});

  final UserModel user;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    removeUser() {
      try {
        Navigator.pop(context, "OK");
        // _userProvider.deleteById(widget.user.id, _userProvider.eventId);
        Toast.success(context, "Localização deletada com sucesso");
      } on DioException catch (e) {
        Toast.danger(context, e.message!);
      }
    }

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
        ], color: Colors.white),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_rounded, color: Colors.black),
                const SizedBox(width: 5),
                Text(widget.user.name,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            GestureDetector(
                onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Você tem certeza?"),
                        content: const Text(
                            "Tem certeza de que deseja excluir este item? Esta ação é irreversível e os dados excluídos não poderão ser recuperados."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, "Cancel"),
                            child: const Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () => removeUser(),
                            child: const Text("Confirmar",
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ),
                child: const Icon(Icons.delete, color: Colors.red))
          ],
        )));
  }
}
