part of 'user_face_photo_bloc.dart';

@immutable
abstract class UserFacePhotoEvent {}

class LoadUserFacePhoto extends UserFacePhotoEvent {}

class UptatedUserFacePhoto extends UserFacePhotoEvent {
  final File image;
  final UserModel user;

  UptatedUserFacePhoto({required this.image, required this.user});
}
