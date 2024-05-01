part of 'point_record_admin_show_bloc.dart';

@immutable
abstract class PointRecordAdminShowEvent {}

class LoadPointRecordAdminShow extends PointRecordAdminShowEvent {
  final int pointRecordId;

  LoadPointRecordAdminShow({required this.pointRecordId});
}
