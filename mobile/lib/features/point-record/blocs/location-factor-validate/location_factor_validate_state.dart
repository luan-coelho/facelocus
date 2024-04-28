part of 'location_factor_validate_bloc.dart';

@immutable
abstract class LocationFactorValidateState {}

class LocationFactorValidateInitial extends LocationFactorValidateState {}

class LocationFactorLoaded extends LocationFactorValidateState {
  final UserAttendanceModel userAttendance;

  LocationFactorLoaded({required this.userAttendance});
}

class LocationFactorValidateLoading extends LocationFactorValidateState {}

class LocationFactorValidateSuccess extends LocationFactorValidateState {}

class LocationFactorValidateError extends LocationFactorValidateState {
  final String message;

  LocationFactorValidateError({required this.message});
}

class GettingLocation extends LocationFactorValidateState {}

class WithinThePermittedRadius extends LocationFactorValidateState {}

class OutsideThePermittedRadius extends LocationFactorValidateState {
  final UserAttendanceModel userAttendance;

  OutsideThePermittedRadius({required this.userAttendance});
}
