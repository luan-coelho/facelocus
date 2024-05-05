import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/features/event-request/blocs/user_event-request-list/user_event_request_list_bloc.dart';
import 'package:facelocus/features/event-request/repositories/event_request_service.dart';
import 'package:facelocus/features/event/blocs/event-request-list/event_request_list_bloc.dart';
import 'package:facelocus/models/event_request_model.dart';
import 'package:facelocus/models/event_request_type_enum.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'event_request_show_event.dart';
part 'event_request_show_state.dart';

class EventRequestShowBloc
    extends Bloc<EventRequestShowEvent, EventRequestShowState> {
  final EventRequestRepository eventRequestRepository;
  final SessionRepository sessionRepository;
  final UserEventRequestListBloc userEventRequestListBloc;
  final EventRequestListBloc eventRequestListBloc;

  EventRequestShowBloc({
    required this.eventRequestRepository,
    required this.sessionRepository,
    required this.userEventRequestListBloc,
    required this.eventRequestListBloc,
  }) : super(EventRequestShowInitial()) {
    on<LoadEventRequest>((event, emit) async {
      try {
        emit(EventRequestShowLoading());
        EventRequestModel er = await eventRequestRepository.getById(
          event.eventRequestId,
        );
        emit(EventRequestShowLoaded(er));
      } on DioException catch (e) {
        emit(EventRequestShowError(ResponseApiMessage.buildMessage(e)));
      }
    });

    on<ApproveEventRequest>((event, emit) async {
      try {
        emit(EventRequestShowLoading());
        var userId = await sessionRepository.getUserId();
        await eventRequestRepository.approve(
          event.eventRequestId,
          userId!,
          event.requestType,
        );
        userEventRequestListBloc.add(LoadAllUserEventRequest());
        eventRequestListBloc.add(LoadAllEventRequest(
          eventId: event.eventId,
        ));
        emit(RequestCompletedSuccessfully());
      } on DioException catch (e) {
        emit(EventRequestShowError(ResponseApiMessage.buildMessage(e)));
      }
    });

    on<RejectEventRequest>((event, emit) async {
      try {
        emit(EventRequestShowLoading());
        await eventRequestRepository.reject(event.eventRequestId);
        userEventRequestListBloc.add(LoadAllUserEventRequest());
        eventRequestListBloc.add(LoadAllEventRequest(
          eventId: event.eventId,
        ));
        emit(RequestCompletedSuccessfully());
      } on DioException catch (e) {
        emit(EventRequestShowError(ResponseApiMessage.buildMessage(e)));
      }
    });
  }
}
