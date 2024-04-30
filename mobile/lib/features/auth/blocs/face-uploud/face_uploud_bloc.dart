import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/shared/user-face-photo/user_face_photo_bloc.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'face_uploud_event.dart';
part 'face_uploud_state.dart';

class FaceUploudBloc extends Bloc<FaceUploudEvent, FaceUploudState> {
  final UserRepository userRepository;
  final SessionRepository sessionRepository;
  final UserFacePhotoBloc userFacePhotoBloc;

  FaceUploudBloc({
    required this.userRepository,
    required this.sessionRepository,
    required this.userFacePhotoBloc,
  }) : super(FaceUploudInitial()) {
    on<UploudPhoto>((event, emit) async {
      try {
        emit(Uploading());
        File file = File(event.path);
        var user = await sessionRepository.getUser();
        await userRepository.facePhotoProfileUploud(file, user!.id!);
        userFacePhotoBloc.add(UptatedUserFacePhoto(image: file, user: user));
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

    on<RequestLogout>((event, emit) async {
      await sessionRepository.logout();
      emit(Logout());
    });
  }
}
