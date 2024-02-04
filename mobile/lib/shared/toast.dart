import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

final class Toast {
  static void showAlert(String message, BuildContext context) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.minimal,
      alignment: Alignment.topCenter,
      title: const Text('Alerta'),
      description: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  static void showSuccess(String message, BuildContext context) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      alignment: Alignment.topCenter,
      title: const Text('Sucesso'),
      description: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  static void showError(String message, BuildContext context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.minimal,
      alignment: Alignment.topCenter,
      title: const Text('Erro'),
      description: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }
}