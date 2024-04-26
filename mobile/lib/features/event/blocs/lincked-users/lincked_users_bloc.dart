import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'lincked_users_event.dart';
part 'lincked_users_state.dart';

class LinckedUsersBloc extends Bloc<LinckedUsersEvent, LinckedUsersState> {
  final UserRepository userRepository;

  LinckedUsersBloc({
    required this.userRepository,
  }) : super(LinckedUsersInitial()) {
    on<LoadLinckedUsers>((event, emit) async {
      try {
        emit(LinckedUsersLoading());
        var users = await userRepository.getAllByEventId(event.eventId);
        if (users.isEmpty) {
          emit(LinckedUsersEmpty());
          return;
        }
        emit(LinckedUsersLoaded(users: users));
      } on DioException catch (e) {
        emit(LinckedUsersError(message: ResponseApiMessage.buildMessage(e)));
      }
    });
  }
}
