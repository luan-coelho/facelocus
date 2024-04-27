part of 'user_face_photo_bloc.dart';

@immutable
abstract class UserFacePhotoEvent {}

class LoadUserFacePhoto extends UserFacePhotoEvent {}

class UpdateUserFacePhoto extends UserFacePhotoEvent {
  final File image;

  UpdateUserFacePhoto({required this.image});
}
