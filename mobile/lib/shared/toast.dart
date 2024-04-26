import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

final class Toast {
  static void showAlert(
    String message,
    BuildContext context, {
    title = 'Alerta',
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.minimal,
      alignment: Alignment.topCenter,
      title: Text(title),
      description: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  static void showSuccess(
    String message,
    BuildContext context, {
    title = 'Sucesso',
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      alignment: Alignment.topCenter,
      title: Text(title),
      description: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  static void showError(
    String message,
    BuildContext context, {
    title = 'Erro',
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.minimal,
      alignment: Alignment.topCenter,
      title: Text(title),
      description: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }
}
