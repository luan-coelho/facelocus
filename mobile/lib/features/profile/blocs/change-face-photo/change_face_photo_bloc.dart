import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/shared/user-face-photo/user_face_photo_bloc.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'change_face_photo_event.dart';

part 'change_face_photo_state.dart';

class ChangeFacePhotoBloc
    extends Bloc<ChangeFacePhotoEvent, ChangeFacePhotoState> {
  final UserRepository userRepository;
  final SessionRepository sessionRepository;
  final UserFacePhotoBloc userFacePhotoBloc;

  ChangeFacePhotoBloc({
    required this.userRepository,
    required this.sessionRepository,
    required this.userFacePhotoBloc,
  }) : super(FaceUploudInitial()) {
    on<UploudPhoto>((event, emit) async {
      try {
        emit(Uploading());
        var user = await sessionRepository.getUser();
        await userRepository.facePhotoProfileUploud(event.file, user!.id!);
        userFacePhotoBloc.add(UptatedUserFacePhoto(
          image: event.file,
          user: user,
        ));
        emit(UploadedSucessfully());
      } on DioException catch (e) {
        emit(UploadedFailed(ResponseApiMessage.buildMessage(e)));
      }
    });

    on<RequestCaptureByGallery>((event, emit) async {
      emit(CapturePhotoByGallery());
    });

    on<RequestCaptureByCamera>((event, emit) async {
      emit(CapturePhotoByCamera());
    });

    on<CameraPhotoCaptured>((event, emit) async {
      emit(CameraPhotoCapturedSuccessfully());
    });

    on<GaleryPhotoCaptured>((event, emit) async {
      emit(GaleryPhotoCapturedSuccessfully());
    });

    on<CancelCapture>((event, emit) async {
      emit(FaceUploudInitial());
    });

    on<RequestCancellation>((event, emit) async {
      await sessionRepository.logout();
      emit(Cancellation());
    });
  }
}
