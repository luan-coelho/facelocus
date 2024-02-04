import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
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

mixin MessageStateMixin {
  final Signal<String?> _successMessage = signal(null);

  String? get successMessage => _successMessage();

  final Signal<String?> _alertMessage = signal(null);

  String? get alertMessage => _alertMessage();

  final Signal<String?> _errorMessage = signal(null);

  String? get errorMessage => _errorMessage();

  void clearSuccess() => _successMessage.value = null;

  void clearAlert() => _alertMessage.value = null;

  void clearError() => _errorMessage.value = null;

  void showSuccess(String message) {
    untracked(() => clearSuccess());
    _successMessage.value = message;
  }

  void showAlert(String message) {
    untracked(() => clearAlert());
    _alertMessage.value = message;
  }

  void showError(String message) {
    untracked(() => clearError());
    _errorMessage.value = message;
  }
}

mixin MessageViewMixin<T extends StatefulWidget> on State<T> {
  void messageListener(MessageStateMixin state) {
    effect(() {
      switch (state) {
        case MessageStateMixin(:final successMessage?):
          Toast.showAlert(successMessage, context);
        case MessageStateMixin(:final alertMessage?):
          Toast.showAlert(alertMessage, context);
        case MessageStateMixin(:final errorMessage?):
          Toast.showAlert(errorMessage, context);
      }
    });
  }
}
