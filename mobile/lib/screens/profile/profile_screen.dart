import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/profile/widgets/change_password.dart';
import 'package:facelocus/screens/profile/widgets/user_face_image.dart';
import 'package:facelocus/shared/constants.dart';
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

    return AppLayout(
        appBarTitle: 'Perfil',
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: Column(
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
                TextButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return const SingleChildScrollView(
                            child: SizedBox(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ChangeUserPassword(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        width: 200,
                        decoration: const BoxDecoration(
                            color: AppColorsConst.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.key, color: Colors.white),
                              SizedBox(width: 5),
                              Text('Alterar senha',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ))),
                const SizedBox(height: 5),
                TextButton(
                    onPressed: () => logout(),
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        width: 200,
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, color: Colors.red),
                              SizedBox(width: 5),
                              Text('Encerrar sessão',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        )))
              ],
            ),
          ),
        ));
  }
}
