part of 'point_record_create_bloc.dart';

@immutable
abstract class PointRecordCreateState {}

class PointRecordCreateInitial extends PointRecordCreateState {}

class PointRecordCreateSuccess extends PointRecordCreateState {}

class PointRecordCreateLoading extends PointRecordCreateState {}

class PointRecordCreateError extends PointRecordCreateState {
  final String message;

  PointRecordCreateError({required this.message});
}
