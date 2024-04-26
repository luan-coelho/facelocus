import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/features/event/repositories/event_repository.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'event_delegate_event.dart';
part 'event_delegate_state.dart';

class EventDelegateBloc extends Bloc<EventDelegateEvent, EventDelegateState> {
  final EventRepository eventRepository;
  final SessionRepository sessionRepository;

  EventDelegateBloc({
    required this.eventRepository,
    required this.sessionRepository,
  }) : super(EventDelegateInitial()) {
    on<LoadAllEvents>((event, emit) async {
      try {
        emit(EventDelegateLoading());
        var events = await eventRepository.getAllByDescription(
          sessionRepository.getUser()!.id!,
          event.description,
        );
        if (events.isEmpty) {
          emit(EventDelegateEmpty());
          return;
        }
        emit(EventDelegateLoaded(events));
      } on DioException catch (e) {
        emit(EventDelegateError(ResponseApiMessage.buildMessage(e)));
      }
    });
  }
}
