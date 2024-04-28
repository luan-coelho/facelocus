part of 'point_record_show_bloc.dart';

@immutable
abstract class PointRecordShowState {}

class PointRecordShowInitial extends PointRecordShowState {}

class PointRecordShowLoading extends PointRecordShowState {}

class PointRecordShowLoaded extends PointRecordShowState {
  final PointRecordModel pointRecord;
  final UserAttendanceModel? userAttendance;
  final bool faceRecognitionFactorValidate;
  final bool locationFactorValidate;

  PointRecordShowLoaded({
    required this.pointRecord,
    this.userAttendance,
    this.faceRecognitionFactorValidate = false,
    this.locationFactorValidate = false,
  });
}

class PointRecordShowError extends PointRecordShowState {
  final String message;

  PointRecordShowError({required this.message});
}
