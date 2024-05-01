part of 'user_attendance_validate_bloc.dart';

@immutable
abstract class UserAttendanceValidateEvent {}

class ValidatePoints extends UserAttendanceValidateEvent {
  final int pointRecordId;
  final List<AttendanceRecordModel?> attendanceRecords;

  ValidatePoints({
    required this.pointRecordId,
    required this.attendanceRecords,
  });
}
