part of 'attendance_record_bloc.dart';

@immutable
abstract class AttendanceRecordEvent {}

class LoadAttendanceRecord extends AttendanceRecordEvent {
  final int attendanceRecordId;

  LoadAttendanceRecord({required this.attendanceRecordId});
}
