import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/features/event-request/repositories/event_request_service.dart';
import 'package:facelocus/models/event_request_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'event_request_list_event.dart';
part 'event_request_list_state.dart';

class EventRequestListBloc
    extends Bloc<EventRequestListEvent, EventRequestListState> {
  final EventRequestRepository eventRequestRepository;
  final SessionRepository sessionRepository;

  EventRequestListBloc({
    required this.eventRequestRepository,
    required this.sessionRepository,
  }) : super(EventRequestListInitial()) {
    on<LoadAllEventRequest>((event, emit) async {
      try {
        emit(EventRequestListLoading());
        var user = await sessionRepository.getUser();
        var eventRequests = await eventRequestRepository.fetchAll(user!.id!);
        emit(EventRequestListLoaded(eventRequests, user));
      } on DioException catch (e) {
        emit(EventRequestListError(ResponseApiMessage.buildMessage(e)));
      }
    });
  }
}
