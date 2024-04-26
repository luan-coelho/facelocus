part of 'lincked_users_delegate_bloc.dart';

@immutable
abstract class LinckedUsersDelegateState {}

class LinckedUsersDelegateInitial extends LinckedUsersDelegateState {}

class LinckedUsersLoaded extends LinckedUsersDelegateState {
  final List<UserModel> users;

  LinckedUsersLoaded({required this.users});
}

class LinckedUsersLoading extends LinckedUsersDelegateState {}

class LinckedUsersEmpty extends LinckedUsersDelegateState {}

class LinckedUsersError extends LinckedUsersDelegateState {
  final String message;

  LinckedUsersError(this.message);
}

class CreateInvitationLoading extends LinckedUsersDelegateState {}

class CreateInvitationSuccess extends LinckedUsersDelegateState {}
