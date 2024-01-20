import 'package:facelocus/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserCardHome extends StatefulWidget {
  const UserCardHome({super.key});

  @override
  State<UserCardHome> createState() => _UserCardHomeState();
}

class _UserCardHomeState extends State<UserCardHome> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
        width: double.infinity,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: const Color(0xff0F172A),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 0.5,
              blurRadius: 0.5,
              offset: const Offset(0, 0.8), // Shadow position
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seja bem-vindo',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w200),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Luan",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.7)),
                  shape: BoxShape.circle),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.profile),
                    child: const CircleAvatar(
                      radius: 30.0, // Define o tamanho do círculo
                      backgroundImage: AssetImage("images/user.jpg"),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
