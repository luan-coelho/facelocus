part of 'lincked_user_bloc.dart';

@immutable
abstract class LinckedUserEvent {}

class RemoveUser extends LinckedUserEvent {
  final int eventId;
  final int userId;

  RemoveUser({
    required this.eventId,
    required this.userId,
  });
}
