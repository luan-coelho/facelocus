part of 'event_show_bloc.dart';

@immutable
abstract class EventShowEvent {}

class EventShowInitialEvent extends EventShowEvent {
  final int eventId;

  EventShowInitialEvent(this.eventId);
}

class ChangeTicketRequestPermission extends EventShowEvent {
  final int eventId;

  ChangeTicketRequestPermission(this.eventId);
}
