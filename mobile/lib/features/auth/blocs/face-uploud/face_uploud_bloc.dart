import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'face_uploud_event.dart';
part 'face_uploud_state.dart';

class FaceUploudBloc extends Bloc<FaceUploudEvent, FaceUploudState> {
  final UserRepository userRepository;
  final SessionRepository sessionRepository;

  FaceUploudBloc({
    required this.userRepository,
    required this.sessionRepository,
  }) : super(FaceUploudInitial()) {
    on<UploudPhoto>((event, emit) async {
      try {
        emit(Uploading());
        File file = File(event.path);
        var user = sessionRepository.getUser()!;
        await userRepository.facePhotoProfileUploud(file, user.id!);
        // _userImagePath.value = file.path;
        emit(UploadedSucessfully());
      } on DioException catch (e) {
        emit(UploadedFailed(ResponseApiMessage.buildMessage(e)));
      }
    });
  }
}
