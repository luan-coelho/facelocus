part of 'point_record_show_bloc.dart';

@immutable
abstract class PointRecordShowState {}

class PointRecordShowInitial extends PointRecordShowState {}

class PointRecordShowLoading extends PointRecordShowState {}

class PointRecordShowLoaded extends PointRecordShowState {
  final PointRecordModel pointRecord;
  final UserAttendanceModel? userAttendance;

  PointRecordShowLoaded({
    required this.pointRecord,
    this.userAttendance,
  });
}

class PointRecordShowError extends PointRecordShowState {
  final String message;

  PointRecordShowError({required this.message});
}
