import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/features/event/blocs/event-list/event_list_bloc.dart';
import 'package:facelocus/features/event/repositories/event_repository.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'event_show_event.dart';
part 'event_show_state.dart';

class EventShowBloc extends Bloc<EventShowEvent, EventShowState> {
  final EventRepository eventRepository;
  final EventListBloc eventListBloc;

  EventShowBloc({
    required this.eventRepository,
    required this.eventListBloc,
  }) : super(EventShowInitial()) {
    on<LoadEvent>((event, emit) async {
      try {
        emit(EventLoading());
        var eventz = await eventRepository.getById(event.eventId);
        emit(EventLoaded(eventz));
      } on DioException catch (e) {
        emit(EventShowError(ResponseApiMessage.buildMessage(e)));
      }
    });

    on<ChangeTicketRequestPermission>((event, emit) async {
      try {
        await eventRepository.changeTicketRequestPermission(event.eventId);
        add(LoadEvent(event.eventId));
        eventListBloc.add(LoadEvents());
      } on DioException catch (e) {
        emit(ChangeTicketRequestPermissionError(
          ResponseApiMessage.buildMessage(e),
        ));
      }
    });
  }
}
