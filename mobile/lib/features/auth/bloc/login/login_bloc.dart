import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/dtos/token_response_dto.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/auth_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<AuthEvent, LoginState> {
  final AuthRepository authRepository;
  final SessionRepository sessionRepository;

  LoginBloc({
    required this.authRepository,
    required this.sessionRepository,
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
  }
}
