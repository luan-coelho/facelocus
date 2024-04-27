part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String authenticatedUserFullName;

  ProfileLoaded({required this.authenticatedUserFullName});
}

class LogoutSuccess extends ProfileState {}
