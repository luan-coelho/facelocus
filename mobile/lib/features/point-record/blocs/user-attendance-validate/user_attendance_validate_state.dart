part of 'user_attendance_validate_bloc.dart';

@immutable
abstract class UserAttendanceValidateState {}

class UserAttendanceValidateInitial extends UserAttendanceValidateState {}

class ValidationSucess extends UserAttendanceValidateState {}

class ValidationLoading extends UserAttendanceValidateState {}

class ValidationFailed extends UserAttendanceValidateState {
  final String message;

  ValidationFailed({required this.message});
}
