part of 'lincked_users_bloc.dart';

@immutable
abstract class LinckedUsersState {}

class LinckedUsersInitial extends LinckedUsersState {}

class LinckedUsersLoading extends LinckedUsersState {}

class LinckedUsersLoaded extends LinckedUsersState {
  final List<UserModel> users;

  LinckedUsersLoaded({required this.users});
}

class LinckedUsersEmpty extends LinckedUsersState {}

class LinckedUsersError extends LinckedUsersState {
  final String message;

  LinckedUsersError({required this.message});
}
