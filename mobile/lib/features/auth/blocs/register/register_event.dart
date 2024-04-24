part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterRequested extends RegisterEvent {
  final UserModel user;

  RegisterRequested({required this.user});
}
