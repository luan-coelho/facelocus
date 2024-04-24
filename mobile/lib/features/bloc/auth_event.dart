part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String login;
  final String password;

  AuthLoginRequested(this.login, this.password);
}
