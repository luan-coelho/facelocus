part of 'face_uploud_bloc.dart';

@immutable
abstract class FaceUploudState {}

class FaceUploudInitial extends FaceUploudState {}

class Uploading extends FaceUploudState {}

class UploadedSucessfully extends FaceUploudState {}

class UploadedFailed extends FaceUploudState {
  final String message;

  UploadedFailed(this.message);
}
