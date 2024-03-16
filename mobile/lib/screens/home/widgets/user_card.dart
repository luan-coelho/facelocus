import 'dart:io';

import 'package:facelocus/controllers/auth/session_controller.dart';
import 'package:facelocus/controllers/user_controller.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class UserCardHome extends StatefulWidget {
  const UserCardHome({super.key});

  @override
  State<UserCardHome> createState() => _UserCardHomeState();
}

class _UserCardHomeState extends State<UserCardHome> {
  late final UserController _controller;
  late final SessionController _authController;
  late final UserModel _user;

  @override
  void initState() {
    _controller = Get.find<UserController>();
    _authController = Get.find<SessionController>();
    _user = _authController.authenticatedUser.value!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => context.push(AppRoutes.profile),
                  child: CircleAvatar(
                    backgroundImage: FileImage(
                      File(_controller.userImagePath.value!),
                    ),
                    radius: 25,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Olá,',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                ),
              ),
              Text(
                _user.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          )
        ],
      );
    });
  }
}
