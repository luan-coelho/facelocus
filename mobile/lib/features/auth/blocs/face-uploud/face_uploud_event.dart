part of 'face_uploud_bloc.dart';

@immutable
abstract class FaceUploudEvent {}

class RequestCaptureByGallery extends FaceUploudEvent {}

class RequestCaptureByCamera extends FaceUploudEvent {}

class CameraPhotoCaptured extends FaceUploudEvent {
  final String path;

  CameraPhotoCaptured({required this.path});
}

class GaleryPhotoCaptured extends FaceUploudEvent {
  final String path;

  GaleryPhotoCaptured({required this.path});
}

class CancelCapture extends FaceUploudEvent {}

class UploudPhoto extends FaceUploudEvent {
  final String path;

  UploudPhoto(this.path);
}

class RequestLogout extends FaceUploudEvent {}
