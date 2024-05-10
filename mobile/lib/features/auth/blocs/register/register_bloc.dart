import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/auth_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc({required this.authRepository}) : super(RegisterInitial()) {
    on<RegisterRequested>(
      (event, emit) async {
        try {
          emit(RegisterLoading());
          await authRepository.register(event.user);
          emit(RegisterSuccess());
        } on DioException catch (e) {
          emit(RegisterError(ResponseApiMessage.buildMessage(e)));
        }
      },
    );
  }
}
