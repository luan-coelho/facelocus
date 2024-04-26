part of 'lincked_user_bloc.dart';

@immutable
abstract class LinckedUserState {}

class LinckedUserInitial extends LinckedUserState {}

class LinckedUserLoading extends LinckedUserState {}

class LinkedUserError extends LinckedUserState {
  final String message;

  LinkedUserError(this.message);
}
