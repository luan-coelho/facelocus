import 'package:dio/dio.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/auth_service.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:facelocus/utils/fields_validator.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  late TextEditingController _cpfController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _isLoading = false;
  Map<String, dynamic>? fieldErrors;

  void _register() async {
    try {
      if (_formKey.currentState!.validate()) {
        AuthService service = AuthService();
        UserModel user = UserModel(
            name: _nameController.text,
            surname: _surnameController.text,
            email: _emailController.text,
            cpf: _cpfController.text,
            password: _passwordController.text);
        updateLoading();
        await service.register(user);
        updateLoading();
        MessageSnacks.success(context, 'Conta criada com sucesso');
      }
    } on DioException catch (e) {
      updateLoading();
      String detail = e.response?.data['detail'];
      if (e.response?.data['invalidFields'] != null) {
        Map<String, dynamic> invalidFields = e.response?.data['invalidFields'];
        setState(() {
          if (invalidFields.isNotEmpty) {
            fieldErrors = invalidFields;
          }
        });
      }
      MessageSnacks.danger(context, detail);
    }
  }

  void updateLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _emailController = TextEditingController();
    _cpfController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: null,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(29.0),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Criar conta',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w600)),
                    const Text('Por favor insira suas informações',
                        style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 25),
                    AppTextField(
                        textEditingController: _nameController,
                        labelText: 'Nome',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Informe o nome'
                            : null),
                    const SizedBox(height: 15),
                    AppTextField(
                        textEditingController: _surnameController,
                        labelText: 'Sobrenome',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Informe o sobrenome'
                            : null),
                    const SizedBox(height: 15),
                    AppTextField(
                        textEditingController: _emailController,
                        labelText: 'Email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o email';
                          }

                          if (!FieldsValidator.validateEmail(
                              _emailController.text)) {
                            return 'Informe um email válido';
                          }

                          return null;
                        }),
                    const SizedBox(height: 15),
                    AppTextField(
                        textEditingController: _cpfController,
                        labelText: 'CPF',
                        maxLength: 14,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o cpf';
                          }

                          if (fieldErrors != null &&
                              fieldErrors!.containsKey('cpf')) {
                            String message = fieldErrors!['cpf'];
                            fieldErrors!.remove('cpf');
                            return message;
                          }

                          if (!FieldsValidator.validateCPF(
                              _cpfController.text)) {
                            return 'Informe um CPF válido';
                          }

                          return null;
                        }),
                    const SizedBox(height: 15),
                    AppTextField(
                        textEditingController: _passwordController,
                        labelText: 'Senha',
                        passwordType: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe a senha';
                          }

                          if (_confirmPasswordController.text.isNotEmpty &&
                              value != _confirmPasswordController.text) {
                            return 'As senhas não coincidem';
                          }

                          return null;
                        }),
                    const SizedBox(height: 15),
                    AppTextField(
                        textEditingController: _confirmPasswordController,
                        labelText: 'Confirmar senha',
                        passwordType: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirme a senha';
                          }

                          if (value != _passwordController.text) {
                            return 'As senhas não coincidem';
                          }

                          return null;
                        }),
                    const SizedBox(height: 25),
                    AppButton(
                        text: 'Cadastrar',
                        onPressed: _register,
                        isLoading: _isLoading),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
