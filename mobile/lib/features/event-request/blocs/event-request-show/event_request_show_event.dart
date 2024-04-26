part of 'event_request_show_bloc.dart';

@immutable
abstract class EventRequestShowEvent {}

class LoadEventRequest extends EventRequestShowEvent {
  final int eventRequestId;

  LoadEventRequest(this.eventRequestId);
}

class ApproveEventRequest extends EventRequestShowEvent {
  final int eventRequestId;
  final EventRequestType requestType;

  ApproveEventRequest({
    required this.eventRequestId,
    required this.requestType,
  });
}

class RejectEventRequest extends EventRequestShowEvent {
  final int eventRequestId;
  final EventRequestType requestType;

  RejectEventRequest(this.eventRequestId, this.requestType);
}
