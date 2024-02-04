import 'package:dio/dio.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/services/auth_service.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RegisterController extends GetxController with MessageStateMixin {
  final AuthService service;
  final Rxn<Map<String, dynamic>> invalidFields = Rxn<Map<String, dynamic>>();

  RegisterController({required this.service});

  void register(BuildContext context, UserModel user) async {
    try {
      await service.register(user);
      if (context.mounted) {
        context.replace(AppRoutes.login);
        showSuccess('Conta criada com sucesso');
      }
    } on DioException catch (e) {
      String detail = e.response?.data['detail'];
      if (e.response?.data['invalidFields'] != null) {
        Map<String, dynamic> invalidFields = e.response?.data['invalidFields'];
        if (invalidFields.isNotEmpty) {
          this.invalidFields.value = invalidFields;
        }
      }
      if (context.mounted) {
        showError(detail);
      }
    }
  }
}
