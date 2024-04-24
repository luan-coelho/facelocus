part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class PointRecordInitial extends HomeState {}

class PointRecordLoading extends HomeState {}

class PointRecordLoaded extends HomeState {
  final UserModel loggedUser;
  final List<NeatCleanCalendarEvent> pointRecordsEventsList;

  PointRecordLoaded({
    required this.loggedUser,
    required this.pointRecordsEventsList,
  });
}

class PointRecordError extends HomeState {
  final String message;

  PointRecordError(this.message);
}
