part of 'face_uploud_bloc.dart';

@immutable
abstract class FaceUploudEvent {}

class RequestCaptureByGallery extends FaceUploudEvent {}

class RequestCaptureByCamera extends FaceUploudEvent {}

class CameraPhotoCaptured extends FaceUploudEvent {
  final File file;

  CameraPhotoCaptured({required this.file});
}

class GaleryPhotoCaptured extends FaceUploudEvent {
  final String path;

  GaleryPhotoCaptured({required this.path});
}

class CancelCapture extends FaceUploudEvent {}

class UploudPhoto extends FaceUploudEvent {
  final File file;

  UploudPhoto({required this.file});
}

class RequestLogout extends FaceUploudEvent {}
