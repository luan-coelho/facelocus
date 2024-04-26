part of 'event_delegate_bloc.dart';

@immutable
abstract class EventDelegateState {}

class EventDelegateInitial extends EventDelegateState {}

class EventDelegateLoading extends EventDelegateState {}

class EventDelegateLoaded extends EventDelegateState {
  final List<EventModel> events;

  EventDelegateLoaded(this.events);
}

class EventDelegateEmpty extends EventDelegateState {}

class EventDelegateError extends EventDelegateState {
  final String message;

  EventDelegateError(this.message);
}
