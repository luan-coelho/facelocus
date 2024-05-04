part of 'change_face_photo_bloc.dart';

@immutable
abstract class ChangeFacePhotoState {}

class FaceUploudInitial extends ChangeFacePhotoState {}

class Uploading extends ChangeFacePhotoState {}

class UploadedSucessfully extends ChangeFacePhotoState {}

class UploadedFailed extends ChangeFacePhotoState {
  final String message;

  UploadedFailed(this.message);
}

class CapturePhotoByGallery extends ChangeFacePhotoState {}

class CapturePhotoByCamera extends ChangeFacePhotoState {}

class CameraPhotoCapturedSuccessfully extends ChangeFacePhotoState {}

class GaleryPhotoCapturedSuccessfully extends ChangeFacePhotoState {}

class Cancellation extends ChangeFacePhotoState {}
