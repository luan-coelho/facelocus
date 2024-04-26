part of 'event_request_show_bloc.dart';

@immutable
abstract class EventRequestShowState {}

class EventRequestShowInitial extends EventRequestShowState {}

class EventRequestShowLoading extends EventRequestShowState {}

class EventRequestShowLoaded extends EventRequestShowState {
  final EventRequestModel eventRequest;

  EventRequestShowLoaded(this.eventRequest);
}

class EventRequestShowError extends EventRequestShowState {
  final String message;

  EventRequestShowError(this.message);
}

class RequestCompleted extends EventRequestShowState {}
