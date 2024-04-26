part of 'face_uploud_bloc.dart';

@immutable
abstract class FaceUploudEvent {}

class UploudPhoto extends FaceUploudEvent {
  final String path;

  UploudPhoto(this.path);
}
