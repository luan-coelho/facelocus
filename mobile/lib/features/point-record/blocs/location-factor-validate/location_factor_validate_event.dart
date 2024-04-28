part of 'location_factor_validate_bloc.dart';

@immutable
abstract class LocationFactorValidateEvent {}

class LoadUserAttendace extends LocationFactorValidateEvent {
  final int userAttendanceId;

  LoadUserAttendace({required this.userAttendanceId});
}

class ValidateLocation extends LocationFactorValidateEvent {
  final UserAttendanceModel userAttendance;

  ValidateLocation({required this.userAttendance});
}
