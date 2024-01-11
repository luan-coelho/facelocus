import 'package:dio/dio.dart';
import 'package:facelocus/dtos/token_response_dto.dart';
import 'package:facelocus/services/auth_service.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
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

  void _login() async {
    try {
      if (_formKey.currentState!.validate()) {
        AuthService service = AuthService();
        String login = _loginController.text;
        String password = _passwordController.text;
        TokenResponse tokenResponse =
            await service.login(context, login, password);
        if (tokenResponse.token.isNotEmpty) {
          context.replace("/home");
          return;
        }
      }
    } on DioException catch (e) {
      var detail = e.response?.data['detail'];
      String message = 'Não foi possível realizar o login';
      MessageSnacks.danger(context, detail ?? message);
    }
  }

  @override
  void initState() {
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
      body: Center(
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
                    const Text('Facelocus',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    AppTextField(
                        textEditingController: _loginController,
                        labelText: 'Login',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Informe o login'
                            : null),
                    const SizedBox(height: 15),
                    AppTextField(
                        textEditingController: _passwordController,
                        labelText: 'Senha',
                        passwordType: true,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Informe a senha'
                            : null),
                    const SizedBox(height: 15),
                    AppButton(text: 'Entrar', onPressed: _login),
                    const SizedBox(height: 10),
                    AppButton(
                        text: 'Cadastrar',
                        onPressed: _login,
                        textColor: Colors.black,
                        backgroundColor: AppColorsConst.white,
                        textFontSize: 14),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
