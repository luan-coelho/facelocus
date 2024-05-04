part of 'change_face_photo_bloc.dart';

@immutable
abstract class ChangeFacePhotoEvent {}

class RequestCaptureByGallery extends ChangeFacePhotoEvent {}

class RequestCaptureByCamera extends ChangeFacePhotoEvent {}

class CameraPhotoCaptured extends ChangeFacePhotoEvent {
  final String path;

  CameraPhotoCaptured({required this.path});
}

class GaleryPhotoCaptured extends ChangeFacePhotoEvent {
  final String path;

  GaleryPhotoCaptured({required this.path});
}

class CancelCapture extends ChangeFacePhotoEvent {}

class UploudPhoto extends ChangeFacePhotoEvent {
  final String path;

  UploudPhoto(this.path);
}

class RequestCancellation extends ChangeFacePhotoEvent {}
