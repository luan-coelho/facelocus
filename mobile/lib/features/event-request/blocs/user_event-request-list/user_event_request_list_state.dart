part of 'user_event_request_list_bloc.dart';

@immutable
abstract class UserEventRequestListState {}

class EventRequestListInitial extends UserEventRequestListState {}

class EventRequestListLoading extends UserEventRequestListState {}

class EventRequestListLoaded extends UserEventRequestListState {
  final List<EventRequestModel> eventRequests;
  final UserModel authenticatedUser;

  EventRequestListLoaded(this.eventRequests, this.authenticatedUser);
}

class EventRequestListEmpty extends UserEventRequestListState {}

class EventRequestListError extends UserEventRequestListState {
  final String message;

  EventRequestListError(this.message);
}
