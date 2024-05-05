part of 'event_request_list_bloc.dart';

@immutable
abstract class EventRequestListEvent {}

class LoadAllEventRequest extends EventRequestListEvent {
  final int eventId;

  LoadAllEventRequest({required this.eventId});
}
