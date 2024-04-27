import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

part 'user_face_photo_event.dart';
part 'user_face_photo_state.dart';

class UserFacePhotoBloc extends Bloc<UserFacePhotoEvent, UserFacePhotoState> {
  final UserRepository userRepository;
  final SessionRepository sessionRepository;

  UserFacePhotoBloc({
    required this.userRepository,
    required this.sessionRepository,
  }) : super(UserFacePhotoInitial()) {
    on<LoadUserFacePhoto>((event, emit) async {
      emit(UserFacePhotoLoading());
      UserModel? loggedUser = await sessionRepository.getUser();
      var response = await userRepository.getFacePhotoById(loggedUser!.id!);

      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/${loggedUser.id}.jpg';
      File imageFile = File(filePath);
      await imageFile.writeAsBytes(response.data!);
      emit(UserFacePhotoLoaded(image: imageFile, user: loggedUser));
    });

    on<UpdateUserFacePhoto>((event, emit) async {
      UserModel? loggedUser = await sessionRepository.getUser();
      emit(UserFacePhotoLoaded(image: event.image, user: loggedUser!));
    });
  }
}
