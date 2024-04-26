import 'package:facelocus/dtos/change_password_dto.dart';
import 'package:facelocus/features/profile/blocs/change-password/change_password_bloc.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangeUserPassword extends StatefulWidget {
  const ChangeUserPassword({super.key});

  @override
  State<ChangeUserPassword> createState() => _ChangeUserPasswordState();
}

class _ChangeUserPasswordState extends State<ChangeUserPassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _currentPassController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPassController;

  @override
  void initState() {
    _currentPassController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPassController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPasswordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(29.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                textEditingController: _currentPassController,
                labelText: 'Senha atual',
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a senha atual'
                    : null,
              ),
              const SizedBox(height: 15),
              AppTextField(
                textEditingController: _newPasswordController,
                labelText: 'Nova senha',
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a nova senha'
                    : null,
              ),
              const SizedBox(height: 15),
              AppTextField(
                textEditingController: _confirmPassController,
                labelText: 'Confirmar senha',
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirme a nova senha';
                  }

                  if (_newPasswordController.text.isNotEmpty &&
                      value != _newPasswordController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                listener: (context, state) {
                  if (state is ChangePasswordSuccess) {
                    context.pop();
                    return Toast.showSuccess(
                      'Senha alterada com sucesso',
                      context,
                    );
                  }

                  if (state is ChangePasswordError) {
                    return Toast.showError(state.message, context);
                  }
                },
                builder: (context, state) {
                  return AppButton(
                    isLoading: state is ChangePasswordLoading,
                    text: 'Alterar',
                    onPressed: () {
                      context.read<ChangePasswordBloc>().add(
                            ChangePassword(
                              credentials: ChangePasswordDTO(
                                currentPassword: _currentPassController.text,
                                newPassword: _newPasswordController.text,
                                confirmPassword: _confirmPassController.text,
                              ),
                            ),
                          );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
