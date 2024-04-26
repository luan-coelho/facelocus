part of 'lincked_users_bloc.dart';

@immutable
abstract class LinckedUsersEvent {}

class LoadLinckedUsers extends LinckedUsersEvent {
  final int eventId;

  LoadLinckedUsers({required this.eventId});
}
