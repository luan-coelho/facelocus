part of 'user_face_photo_bloc.dart';

@immutable
abstract class UserFacePhotoState {}

class UserFacePhotoInitial extends UserFacePhotoState {}

class UserFacePhotoLoading extends UserFacePhotoState {}

class UserFacePhotoLoaded extends UserFacePhotoState {
  final File image;
  final UserModel user;

  UserFacePhotoLoaded({required this.image, required this.user});
}

class UserFacePhotoError extends UserFacePhotoState {
  final String message;

  UserFacePhotoError(this.message);
}
