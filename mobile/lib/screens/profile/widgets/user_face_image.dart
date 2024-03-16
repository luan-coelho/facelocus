import 'dart:io';

import 'package:facelocus/controllers/user_controller.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class UserFaceImage extends StatefulWidget {
  const UserFaceImage({super.key});

  @override
  State<UserFaceImage> createState() => _UserFaceImageState();
}

class _UserFaceImageState extends State<UserFaceImage> {
  late final UserController _controller;

  @override
  void initState() {
    _controller = Get.find<UserController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Builder(builder: (context) {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundImage: FileImage(
                File(_controller.userImagePath.value!),
              ),
              radius: 100,
            ),
          );
        }),
        Positioned(
          right: 30,
          bottom: -2,
          child: GestureDetector(
            onTap: () => context.push(AppRoutes.changeFacePhoto),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColorsConst.blue,
                border: Border.all(color: Colors.white, width: 3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                size: 30.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
