part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class Logout extends ProfileEvent {}
