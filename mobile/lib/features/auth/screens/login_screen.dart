import 'package:facelocus/features/auth/blocs/login/login_bloc.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _loginController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    context.read<LoginBloc>().add(CheckAuth());
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.replace(AppRoutes.home);
          }

          if (state is TokenExpired) {
            Toast.showAlert(
              title: 'Sessão Expirada',
              'Sua sessão expirou, faça login novamente',
              context,
            );
          }

          if (state is LoginError) {
            Toast.showError(
              title: 'Erro de Autenticação',
              state.message,
              context,
            );
          }

          if (state is UserWithoutFacePhoto) {
            context.replace(AppRoutes.userUploadFacePhoto);
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(29.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'images/login.svg',
                        width: 280,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Facelocus',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      AppTextField(
                        textEditingController: _loginController,
                        labelText: 'Login',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Informe o login'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      AppTextField(
                        textEditingController: _passwordController,
                        labelText: 'Senha',
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Informe a senha'
                            : null,
                      ),
                      const SizedBox(height: 15),
                      AppButton(
                        text: 'Entrar',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<LoginBloc>().add(
                                  LoginRequested(
                                    _loginController.text,
                                    _passwordController.text,
                                  ),
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                        text: 'Cadastrar',
                        onPressed: () => context.push(AppRoutes.register),
                        textColor: Colors.black,
                        backgroundColor: AppColorsConst.white,
                        textFontSize: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
