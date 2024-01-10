import 'package:dio/dio.dart';
import 'package:facelocus/dtos/token_response_dto.dart';
import 'package:facelocus/services/auth_service.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/material.dart';
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

  late FocusNode _emailFocusNode;
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (_emailFocusNode.hasPrimaryFocus) {
        return;
      }
      _emailFocusNode.canRequestFocus = false;
    });
  }

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
      MessageSnacks.danger(context,
          e.response?.data['detail'] ?? 'Não foi possível realizar o login');
    }
  }

  @override
  void initState() {
    _emailFocusNode = FocusNode();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
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
                    // Image.asset('images/box.png'),
                    const Text('Facelocus',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 45, fontWeight: FontWeight.w600)),
                    Container(
                      padding: const EdgeInsets.only(top: 45),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Login",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start),
                          const SizedBox(height: 3),
                          TextFormField(
                            controller: _loginController,
                            focusNode: _emailFocusNode,
                            autofocus: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe o email';
                              }

                              if (value.length <= 3) {
                                return 'Informe pelo 3 caracteres para o login';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              isDense: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff0F172A), width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(203, 213, 225, 1),
                                      width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              prefixIcon: Icon(Icons.email, size: 24),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Senha",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start),
                          const SizedBox(height: 3),
                          TextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscured,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe a senha';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              isDense: true,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff0F172A), width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(203, 213, 225, 1),
                                      width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              prefixIcon: const Icon(Icons.key, size: 24),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                child: GestureDetector(
                                  onTap: _toggleObscured,
                                  child: Icon(
                                    _obscured
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: SizedBox(
                          width: double.infinity, // Largura 100%
                          height: 50, // Altura de 50
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColorsConst.blue),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ))),
                            onPressed: () {
                              _login();
                            },
                            child: const Text("Entrar",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20)),
                          ),
                        )),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity, // Largura 100%
                      height: 50, // Altura de 50
                      child: TextButton(
                        style: ButtonStyle(
                            shadowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.black),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                        onPressed: () {
                          _login();
                        },
                        child: const Text("Criar conta",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20)),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
