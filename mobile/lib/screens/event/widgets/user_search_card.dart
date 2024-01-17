import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/screens/profile/widgets/user_face_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserSearchCard extends StatefulWidget {
  const UserSearchCard({super.key, required this.user});

  final UserModel user;

  @override
  State<UserSearchCard> createState() => _UserSearchCardState();
}

class _UserSearchCardState extends State<UserSearchCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(29.0),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 20,
            decoration:
                const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const CircleAvatar(
              radius: 100.0,
              backgroundImage: AssetImage("images/man-face.jpg"),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Text(widget.user.getFullName()),
              const SizedBox(height: 5),
              Text(widget.user.cpf)
            ],
          )
        ],
      ),
    );
  }
}
