import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/auth_repository.dart';
import 'package:flutter/material.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository repository;

  RegisterBloc({required this.repository}) : super(RegisterInitial()) {
    on<RegisterRequested>((event, emit) async {
      try {
        await repository.register(event.user);
        emit(RegisterSuccess());
      } on DioException catch (e) {
        String detail = e.response?.data['detail'];
        if (e.response?.data['detail'] != null) {
          detail = e.response?.data['detail'];
        }
        emit(RegisterError(detail));
      }
    });
  }
}
