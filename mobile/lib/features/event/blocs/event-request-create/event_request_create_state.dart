part of 'event_request_create_bloc.dart';

@immutable
abstract class EventRequestCreateState {}

class EventRequestCreateInitial extends EventRequestCreateState {}

class TicketRequestCreateLoading extends EventRequestCreateState {}

class TicketRequestCreateSuccess extends EventRequestCreateState {}

class TicketRequestCreateError extends EventRequestCreateState {
  final String message;

  TicketRequestCreateError(this.message);
}
