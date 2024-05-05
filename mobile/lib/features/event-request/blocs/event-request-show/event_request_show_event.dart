part of 'event_request_show_bloc.dart';

@immutable
abstract class EventRequestShowEvent {}

class LoadEventRequest extends EventRequestShowEvent {
  final int eventRequestId;

  LoadEventRequest(this.eventRequestId);
}

class ApproveEventRequest extends EventRequestShowEvent {
  final int eventRequestId;
  final int eventId;
  final EventRequestType requestType;

  ApproveEventRequest({
    required this.eventRequestId,
    required this.eventId,
    required this.requestType,
  });
}

class RejectEventRequest extends EventRequestShowEvent {
  final int eventRequestId;
  final int eventId;
  final EventRequestType requestType;

  RejectEventRequest({
    required this.eventRequestId,
    required this.eventId,
    required this.requestType,
  });
}
