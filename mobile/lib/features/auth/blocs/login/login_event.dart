part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginRequested extends LoginEvent {
  final String login;
  final String password;

  LoginRequested(this.login, this.password);
}

class CheckAuth extends LoginEvent {}
