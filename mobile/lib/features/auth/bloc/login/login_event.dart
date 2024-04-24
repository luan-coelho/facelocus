part of 'login_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String login;
  final String password;

  LoginRequested(this.login, this.password);
}
