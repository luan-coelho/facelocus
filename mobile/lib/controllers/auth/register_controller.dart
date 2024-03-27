import 'package:dio/dio.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/services/auth_service.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RegisterController extends GetxController {
  final AuthRepository repository;
  final Rxn<Map<String, dynamic>> invalidFields = Rxn<Map<String, dynamic>>();

  RegisterController({required this.repository});

  void register(BuildContext context, UserModel user) async {
    try {
      await repository.register(user);
      Toast.showSuccess('Conta criada com sucesso', context);
      context.replace(AppRoutes.login);
    } on DioException catch (e) {
      String detail = e.response?.data['detail'];
      if (e.response?.data['invalidFields'] != null) {
        Map<String, dynamic> invalidFields = e.response?.data['invalidFields'];
        if (invalidFields.isNotEmpty) {
          this.invalidFields.value = invalidFields;
        }
      }
      if (context.mounted) {
        Toast.showError(detail, context);
      }
    }
  }
}
