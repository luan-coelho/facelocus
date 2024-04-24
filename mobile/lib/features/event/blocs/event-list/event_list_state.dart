part of 'event_list_bloc.dart';

@immutable
abstract class EventListState {}

class EventListInitial extends EventListState {}

class EventsLoading extends EventListState {}

class EventsLoaded extends EventListState {
  final List<EventModel> events;

  EventsLoaded(this.events);
}

class EventsEmpty extends EventListState {}

class EventsError extends EventListState {
  final String message;

  EventsError(this.message);
}
