part of 'change_face_photo_bloc.dart';

@immutable
abstract class ChangeFacePhotoEvent {}

class RequestCaptureByGallery extends ChangeFacePhotoEvent {}

class RequestCaptureByCamera extends ChangeFacePhotoEvent {}

class CameraPhotoCaptured extends ChangeFacePhotoEvent {
  final File file;

  CameraPhotoCaptured({required this.file});
}

class GaleryPhotoCaptured extends ChangeFacePhotoEvent {
  final String path;

  GaleryPhotoCaptured({required this.path});
}

class CancelCapture extends ChangeFacePhotoEvent {}

class UploudPhoto extends ChangeFacePhotoEvent {
  final File file;

  UploudPhoto({required this.file});
}

class RequestCancellation extends ChangeFacePhotoEvent {}
