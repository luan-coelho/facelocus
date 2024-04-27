part of 'er_user_face_photo_bloc.dart';

@immutable
abstract class ErUserFacePhotoState {}

class ErUserFacePhotoInitial extends ErUserFacePhotoState {}

class ErUserFacePhotoLoading extends ErUserFacePhotoState {}

class ErUserFacePhotoLoaded extends ErUserFacePhotoState {
  final File image;
  final UserModel user;

  ErUserFacePhotoLoaded({required this.image, required this.user});
}

class ErUserFacePhotoError extends ErUserFacePhotoState {
  final String message;

  ErUserFacePhotoError(this.message);
}
