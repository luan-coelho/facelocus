import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class ChangeUserPassword extends StatefulWidget {
  const ChangeUserPassword({super.key});

  @override
  State<ChangeUserPassword> createState() => _ChangeUserPasswordState();
}

class _ChangeUserPasswordState extends State<ChangeUserPassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  void _login() async {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  void initState() {
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(29.0),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppTextField(
                  textEditingController: _currentPasswordController,
                  labelText: 'Senha atual',
                  passwordType: true,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Informe a senha atual'
                      : null),
              const SizedBox(height: 15),
              AppTextField(
                  textEditingController: _newPasswordController,
                  labelText: 'Nova senha',
                  passwordType: true,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Informe a nova senha'
                      : null),
              const SizedBox(height: 15),
              AppTextField(
                  textEditingController: _confirmPasswordController,
                  labelText: 'Confirmar senha',
                  passwordType: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirme a nova senha';
                    }

                    if (_newPasswordController.text.isNotEmpty && value != _newPasswordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  }),
              const SizedBox(height: 15),
              AppButton(text: 'Alterar', onPressed: _login)
            ]),
          )),
    );
  }
}
