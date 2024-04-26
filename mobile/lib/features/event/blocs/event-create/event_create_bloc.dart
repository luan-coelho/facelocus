import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/features/event/blocs/event-list/event_list_bloc.dart';
import 'package:facelocus/features/event/repositories/event_repository.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'event_create_event.dart';
part 'event_create_state.dart';

class EventCreateBloc extends Bloc<EventCreateEvent, EventCreateState> {
  final EventRepository eventRepository;
  final SessionRepository sessionRepository;
  final EventListBloc eventListBloc;

  EventCreateBloc({
    required this.eventRepository,
    required this.sessionRepository,
    required this.eventListBloc,
  }) : super(EventCreateInitial()) {
    on<EventCreate>((event, emit) async {
      try {
        emit(EventCreateLoading());
        EventModel e = EventModel(
          description: event.description,
          allowTicketRequests: event.allowTicketRequests,
          administrator: await sessionRepository.getUserFuture(),
        );
        EventModel eventCreated = await eventRepository.create(e);
        eventListBloc.add(LoadEvents());
        emit(EventCreateSuccess(eventId: eventCreated.id!));
      } on DioException catch (e) {
        emit(EventCreateError(ResponseApiMessage.buildMessage(e)));
      }
    });
  }
}
