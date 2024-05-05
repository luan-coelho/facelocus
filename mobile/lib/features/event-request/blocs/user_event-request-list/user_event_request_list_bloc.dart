import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/features/event-request/repositories/event_request_service.dart';
import 'package:facelocus/models/event_request_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'user_event_request_list_event.dart';
part 'user_event_request_list_state.dart';

class UserEventRequestListBloc
    extends Bloc<UserEventRequestListEvent, UserEventRequestListState> {
  final EventRequestRepository eventRequestRepository;
  final SessionRepository sessionRepository;

  UserEventRequestListBloc({
    required this.eventRequestRepository,
    required this.sessionRepository,
  }) : super(EventRequestListInitial()) {
    on<LoadAllUserEventRequest>((event, emit) async {
      try {
        emit(EventRequestListLoading());
        var user = await sessionRepository.getUser();
        var eventRequests = await eventRequestRepository.fetchAllByUserId(
          user!.id!,
        );
        if (eventRequests.isEmpty) {
          emit(EventRequestListEmpty());
          return;
        }
        emit(EventRequestListLoaded(eventRequests, user));
      } on DioException catch (e) {
        emit(EventRequestListError(ResponseApiMessage.buildMessage(e)));
      }
    });
  }
}
