import 'package:facelocus/controllers/auth/session_controller.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/profile/widgets/change_password.dart';
import 'package:facelocus/screens/profile/widgets/user_face_image.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/information_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final SessionController _controller;
  late final UserModel _user;

  @override
  void initState() {
    _controller = Get.find<SessionController>();
    _user = _controller.authenticatedUser.value!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logout() {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      _controller.logout();
      storage.delete(key: 'token');
      context.replace(AppRoutes.login);
    }

    showModal() {
      showModalBottomSheet<void>(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: const ChangeUserPassword(),
          );
        },
      );
    }

    return AppLayout(
      showBottomNavigationBar: false,
      appBarTitle: 'Perfil',
      body: Padding(
        padding: const EdgeInsets.all(29),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const UserFaceImage(),
            const SizedBox(height: 55),
            InformationField(
              description: 'Nome Completo',
              value: _user.getFullName(),
            ),
            const SizedBox(height: 35),
            AppButton(
              text: 'Alterar senha',
              onPressed: showModal,
              icon: const Icon(Icons.key, color: Colors.white),
            ),
            const SizedBox(height: 10),
            AppButton(
              text: 'Sair',
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: logout,
              textColor: Colors.red,
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
