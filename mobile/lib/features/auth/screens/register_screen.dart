import 'package:facelocus/features/auth/bloc/register/register_bloc.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:facelocus/utils/fields_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  late TextEditingController _cpfController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPassController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _emailController = TextEditingController();
    _cpfController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPassController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: context.pop,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Toast.showSuccess('Conta criada com sucesso', context);
              context.replace(AppRoutes.login);
            }
            if (state is RegisterError) {
              Toast.showError(
                title: 'Erro de Validação',
                state.message,
                context,
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(29.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    const Text(
                      'Criar conta',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'Por favor insira suas informações',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 25),
                    AppTextField(
                      textEditingController: _nameController,
                      labelText: 'Nome',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe o nome'
                          : null,
                    ),
                    const SizedBox(height: 15),
                    AppTextField(
                      textEditingController: _surnameController,
                      labelText: 'Sobrenome',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe o sobrenome'
                          : null,
                    ),
                    const SizedBox(height: 15),
                    AppTextField(
                      textEditingController: _cpfController,
                      keyboardType: TextInputType.number,
                      labelText: 'CPF',
                      maxLength: 14,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o cpf';
                        }

                        if (!FieldsValidator.validateCPF(_cpfController.text)) {
                          return 'Informe um CPF válido';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    AppTextField(
                      textEditingController: _emailController,
                      labelText: 'Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o email';
                        }

                        if (!FieldsValidator.validateEmail(
                          _emailController.text,
                        )) {
                          return 'Informe um email válido';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    AppTextField(
                      textEditingController: _passwordController,
                      labelText: 'Senha',
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a senha';
                        }

                        if (_confirmPassController.text.isNotEmpty &&
                            value != _confirmPassController.text) {
                          return 'As senhas não coincidem';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    AppTextField(
                      textEditingController: _confirmPassController,
                      labelText: 'Confirmar senha',
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirme a senha';
                        }

                        if (value != _passwordController.text) {
                          return 'As senhas não coincidem';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    AppButton(
                      text: 'Cadastrar',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<RegisterBloc>().add(
                                RegisterRequested(
                                  user: UserModel(
                                    name: _nameController.text,
                                    surname: _surnameController.text,
                                    email: _emailController.text,
                                    cpf: _cpfController.text,
                                    password: _passwordController.text,
                                  ),
                                ),
                              );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
