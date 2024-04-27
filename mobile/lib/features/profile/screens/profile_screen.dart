import 'package:facelocus/features/profile/blocs/profile/profile_bloc.dart';
import 'package:facelocus/features/profile/screens/change_password.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/profile/widgets/user_face_image.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    context.read<ProfileBloc>().add(LoadProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 25),
            BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  Toast.showAlert(
                    title: 'Até logo!',
                    'Obrigado por usar o FaceLocus!'
                    'Esperamos vê-lo novamente em breve.',
                    seconds: 7,
                    context,
                  );
                  clearAndNavigate(AppRoutes.login);
                }
              },
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return Text(
                    state.authenticatedUserFullName.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  );
                }
                return const Center(child: Spinner());
              },
            ),
            const SizedBox(height: 25),
            AppButton(
              text: 'Alterar senha',
              onPressed: showModal,
              icon: const Icon(Icons.key, color: Colors.white),
            ),
            const SizedBox(height: 10),
            AppButton(
              text: 'Sair',
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () async => context.read<ProfileBloc>().add(Logout()),
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
