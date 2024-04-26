part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginSuccess extends LoginState {}

class TokenExpired extends LoginState {}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}

class UserWithoutFacePhoto extends LoginState {}

class LoginLoading extends LoginState {}

class Unauthorized extends LoginState {}
