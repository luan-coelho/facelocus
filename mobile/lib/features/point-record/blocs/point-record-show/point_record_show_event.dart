part of 'point_record_show_bloc.dart';

@immutable
abstract class PointRecordShowEvent {}

class LoadPointRecord extends PointRecordShowEvent {
  final int pointRecordId;

  LoadPointRecord({required this.pointRecordId});
}

class LoadUserAttendance extends PointRecordShowEvent {
  final int pointRecordId;

  LoadUserAttendance({required this.pointRecordId});
}
