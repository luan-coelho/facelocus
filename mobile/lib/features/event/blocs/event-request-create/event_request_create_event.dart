part of 'event_request_create_bloc.dart';

@immutable
abstract class EventRequestCreateEvent {}

class CreateTicketRequest extends EventRequestCreateEvent {
  final String code;

  CreateTicketRequest({required this.code});
}
