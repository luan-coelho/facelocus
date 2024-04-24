import 'dart:io';

import 'package:facelocus/controllers/user_controller.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserCardER extends StatefulWidget {
  const UserCardER({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  State<UserCardER> createState() => _UserCardERState();
}

class _UserCardERState extends State<UserCardER> {
  late final UserController _controller;

  @override
  void initState() {
    _controller = Get.find<UserController>();
    _controller.fetchFacePhotoByUserIdEr(context, widget.user.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.imageLoading.value) {
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: const Skeletonizer.zone(
            child: Bone.circle(size: 200),
          ),
        );
      }
      return Container(
        width: 200,
        height: 200,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: CircleAvatar(
          backgroundImage: FileImage(
            File(_controller.userErImagePath.value!),
          ),
          radius: 25,
        ),
      );
    });
  }
}
