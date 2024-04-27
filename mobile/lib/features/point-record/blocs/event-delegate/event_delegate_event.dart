part of 'event_delegate_bloc.dart';

@immutable
abstract class EventDelegateEvent {}

class LoadAllEvents extends EventDelegateEvent {
  final String description;

  LoadAllEvents({required this.description});
}
