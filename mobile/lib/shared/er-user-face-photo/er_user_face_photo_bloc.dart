import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

part 'er_user_face_photo_event.dart';
part 'er_user_face_photo_state.dart';

class ErUserFacePhotoBloc
    extends Bloc<ErUserFacePhotoEvent, ErUserFacePhotoState> {
  final UserRepository userRepository;
  final SessionRepository sessionRepository;

  ErUserFacePhotoBloc({
    required this.userRepository,
    required this.sessionRepository,
  }) : super(ErUserFacePhotoInitial()) {
    on<LoadErUserFacePhoto>((event, emit) async {
      emit(ErUserFacePhotoLoading());
      UserModel user = event.user;
      var response = await userRepository.getFacePhotoById(user.id!);

      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/${user.id}.jpg';
      File imageFile = File(filePath);
      await imageFile.writeAsBytes(response.data!);
      emit(ErUserFacePhotoLoaded(image: imageFile, user: user));
    });
  }
}
