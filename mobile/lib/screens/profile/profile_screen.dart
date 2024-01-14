import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/profile/widgets/change_password.dart';
import 'package:facelocus/screens/profile/widgets/user_face_image.dart';
import 'package:facelocus/services/auth_service.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthController authController;

  @override
  void initState() {
    authController = AuthController(service: AuthService());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logout() {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      authController.logout();
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
                const SizedBox(height: 50),
                const Text(
                  'Nome Completo',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w200),
                ),
                const SizedBox(height: 2),
                Text(
                  'Luan Coêlho de Souza'.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                const Text(
                  'CPF',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w200),
                ),
                const SizedBox(height: 2),
                const Text(
                  '414.949.080-50',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Email',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w200),
                ),
                const SizedBox(height: 2),
                const Text(
                  'joa***@gmail.com',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),
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
