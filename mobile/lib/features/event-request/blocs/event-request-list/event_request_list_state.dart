part of 'event_request_list_bloc.dart';

@immutable
abstract class EventRequestListState {}

class EventRequestListInitial extends EventRequestListState {}

class EventRequestListLoading extends EventRequestListState {}

class EventRequestListLoaded extends EventRequestListState {
  final List<EventRequestModel> eventRequests;
  final UserModel authenticatedUser;

  EventRequestListLoaded(this.eventRequests, this.authenticatedUser);
}

class EventRequestListError extends EventRequestListState {
  final String message;

  EventRequestListError(this.message);
}
