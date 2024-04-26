part of 'lincked_users_delegate_bloc.dart';

@immutable
abstract class LinckedUsersDelegateEvent {}

class LoadAllUsers extends LinckedUsersDelegateEvent {
  final String query;
  final int eventId;

  LoadAllUsers({required this.query, required this.eventId});
}

class CreateEnviation extends LinckedUsersDelegateEvent {
  final int eventId;
  final int userId;

  CreateEnviation({required this.eventId, required this.userId});
}
