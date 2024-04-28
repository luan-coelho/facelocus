part of 'attendance_record_bloc.dart';

@immutable
abstract class AttendanceRecordState {}

class AttendanceRecordInitial extends AttendanceRecordState {}

class AttendanceRecordLoading extends AttendanceRecordState {}

class AttendanceRecordLoaded extends AttendanceRecordState {
  final AttendanceRecordModel attendanceRecord;

  AttendanceRecordLoaded({required this.attendanceRecord});
}

class AttendanceRecordError extends AttendanceRecordState {
  final String message;

  AttendanceRecordError({required this.message});
}
