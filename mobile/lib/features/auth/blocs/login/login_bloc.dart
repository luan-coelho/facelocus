import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/dtos/token_response_dto.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/auth_repository.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/shared/user-face-photo/user_face_photo_bloc.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final SessionRepository sessionRepository;
  final UserFacePhotoBloc userFacePhotoBloc;

  LoginBloc({
    required this.authRepository,
    required this.userRepository,
    required this.sessionRepository,
    required this.userFacePhotoBloc,
  }) : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      try {
        emit(LoginLoading());
        TokenResponse tokenResponse = await authRepository.login(
          event.login,
          event.password,
        );

        if (tokenResponse.token.isNotEmpty) {
          String token = tokenResponse.token;
          await sessionRepository.saveToken(token);
          UserModel user = tokenResponse.user;
          sessionRepository.saveUser(user);

          if (user.facePhoto == null) {
            emit(UserWithoutFacePhoto());
            return;
          }
          userFacePhotoBloc.add(FetchUserFacePhoto());
          emit(LoginSuccess());
        }
      } on DioException catch (e) {
        String detail = 'Não foi possível realizar o login';
        if (e.response?.data['detail'] != null) {
          detail = e.response?.data['detail'];
        }
        emit(LoginError(detail));
      }
    });

    on<CheckAuth>((event, emit) async {
      try {
        var loggedUserId = await sessionRepository.getUserId();
        if (loggedUserId == null) {
          emit(LoginInitial());
          return;
        }

        UserModel loggedUser = await userRepository.getById(loggedUserId);
        if (loggedUser.facePhoto == null) {
          emit(UserWithoutFacePhoto());
          return;
        }
        userFacePhotoBloc.add(FetchUserFacePhoto());
        emit(LoginSuccess());
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          sessionRepository.logout();
          emit(TokenExpired());
        }

        String message = 'Não foi possível realizar o login';
        if (e.response?.data['detail'] != null) {
          message = e.response?.data['detail'];
        }
        emit(LoginError(message));
      }
    });
  }
}
