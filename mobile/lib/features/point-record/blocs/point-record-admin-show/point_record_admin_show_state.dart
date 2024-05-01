part of 'point_record_admin_show_bloc.dart';

@immutable
abstract class PointRecordAdminShowState {}

class PointRecordAdminShowInitial extends PointRecordAdminShowState {}

class PointRecordAdminShowLoading extends PointRecordAdminShowState {}

class PointRecordAdminShowLoaded extends PointRecordAdminShowState {
  final PointRecordModel pointRecord;
  final List<UserAttendanceModel> userAttendances;

  PointRecordAdminShowLoaded({
    required this.pointRecord,
    required this.userAttendances,
  });
}

class NoLinckedUsers extends PointRecordAdminShowState {
  final int pointRecordId;

  NoLinckedUsers({required this.pointRecordId});
}

class PointRecordAdminShowError extends PointRecordAdminShowState {
  final String message;

  PointRecordAdminShowError({required this.message});
}

class SuccessfullDeletion extends PointRecordAdminShowState {}
