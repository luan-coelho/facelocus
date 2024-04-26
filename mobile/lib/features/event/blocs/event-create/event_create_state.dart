part of 'event_create_bloc.dart';

@immutable
abstract class EventCreateState {}

class EventCreateInitial extends EventCreateState {}

class EventCreateSuccess extends EventCreateState {
  final int eventId;

  EventCreateSuccess({required this.eventId});
}

class EventCreateLoading extends EventCreateState {}

class EventCreateError extends EventCreateState {
  final String message;

  EventCreateError(this.message);
}
