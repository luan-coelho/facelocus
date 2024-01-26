import 'package:facelocus/controllers/auth_controller.dart';
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
  late final AuthController _controller;
  late final UserModel _user;

  @override
  void initState() {
    _controller = Get.find<AuthController>();
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
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2 +
                MediaQuery.of(context).viewInsets.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChangeUserPassword(),
              ],
            ),
          );
        },
      );
    }

    return AppLayout(
        appBarTitle: 'Perfil',
        body: Padding(
          padding: const EdgeInsets.all(45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const UserFaceImage(),
              const SizedBox(height: 25),
              InformationField(
                  description: 'Nome Completo', value: _user.getFullName()),
              const SizedBox(height: 15),
              InformationField(description: 'CPF', value: _user.cpf),
              const SizedBox(height: 15),
              InformationField(description: 'Email', value: _user.email),
              const SizedBox(height: 25),
              AppButton(
                  text: 'Alterar senha',
                  onPressed: showModal,
                  icon: const Icon(Icons.key, color: Colors.white)),
              const SizedBox(height: 5),
              AppButton(
                  text: 'Encerrar sessão',
                  onPressed: logout,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  backgroundColor: Colors.red)
            ],
          ),
        ));
  }
}
