part of 'event_show_bloc.dart';

@immutable
abstract class EventShowEvent {}

class LoadEvent extends EventShowEvent {
  final int eventId;

  LoadEvent(this.eventId);
}

class ChangeTicketRequestPermission extends EventShowEvent {
  final int eventId;

  ChangeTicketRequestPermission(this.eventId);
}
