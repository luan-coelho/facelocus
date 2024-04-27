part of 'er_user_face_photo_bloc.dart';

@immutable
abstract class ErUserFacePhotoEvent {}

class LoadErUserFacePhoto extends ErUserFacePhotoEvent {
  final UserModel user;

  LoadErUserFacePhoto({required this.user});
}
