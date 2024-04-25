part of 'event_create_bloc.dart';

@immutable
abstract class EventCreateEvent {}

class EventCreate extends EventCreateEvent {
  final String description;
  final bool allowTicketRequests;

  EventCreate({
    required this.description,
    required this.allowTicketRequests,
  });
}
