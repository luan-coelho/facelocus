part of 'event_show_bloc.dart';

@immutable
abstract class EventShowState {}

class EventShowInitial extends EventShowState {}

class EventLoading extends EventShowState {}

class EventLoaded extends EventShowState {
  final EventModel event;

  EventLoaded(this.event);
}

class EventShowError extends EventShowState {
  final String message;

  EventShowError(this.message);
}

class ChangeTicketRequestPermissionError extends EventShowState {
  final String message;

  ChangeTicketRequestPermissionError(this.message);
}

class ExportLoading extends EventShowState {}

class EventExportedSuccessfully extends EventShowState {
  final String message;

  EventExportedSuccessfully({required this.message});
}

class ExportEventError extends EventShowState {
  final String message;

  ExportEventError({required this.message});
}
