import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/dtos/change_password_dto.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final UserRepository userRepository;
  final SessionRepository sessionRepository;

  ChangePasswordBloc({
    required this.userRepository,
    required this.sessionRepository,
  }) : super(ChangePasswordInitial()) {
    on<ChangePassword>((event, emit) async {
      try {
        emit(ChangePasswordLoading());
        int? userId = await sessionRepository.getUserId();
        await userRepository.changePassword(userId!, event.credentials);
        emit(ChangePasswordSuccess());
      } on DioException catch (e) {
        emit(ChangePasswordError(ResponseApiMessage.buildMessage(e)));
      }
    });
  }
}
