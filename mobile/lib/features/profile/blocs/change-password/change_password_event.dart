part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordEvent {}

class ChangePassword extends ChangePasswordEvent {
  final ChangePasswordDTO credentials;

  ChangePassword({required this.credentials});
}
