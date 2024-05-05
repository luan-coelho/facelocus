part of 'event_request_list_bloc.dart';

@immutable
abstract class EventRequestListState {}

class EventRequestListInitial extends EventRequestListState {}

class EventRequestListLoading extends EventRequestListState {}

class EventRequestListLoaded extends EventRequestListState {
  final List<EventRequestModel> eventRequests;
  final UserModel authenticatedUser;

  EventRequestListLoaded({
    required this.eventRequests,
    required this.authenticatedUser,
  });
}

class EventRequestListEmpty extends EventRequestListState {}

class EventRequestListError extends EventRequestListState {
  final String message;

  EventRequestListError(this.message);
}
