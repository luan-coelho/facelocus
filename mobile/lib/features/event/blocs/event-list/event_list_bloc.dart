import 'package:bloc/bloc.dart';
import 'package:facelocus/features/event/repository/event_repository.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:flutter/material.dart';

part 'event_list_event.dart';
part 'event_list_state.dart';

class EventListBloc extends Bloc<EventListEvent, EventListState> {
  final EventRepository eventRepository;
  final SessionRepository sessionRepository;

  EventListBloc({
    required this.eventRepository,
    required this.sessionRepository,
  }) : super(EventListInitial()) {
    on<FetchEvents>((event, emit) async {
      emit(EventsLoading());
      int? loggedUserId = await sessionRepository.getUserId();
      var events = await eventRepository.getAllByUser(loggedUserId!);
      if (events.isEmpty) {
        emit(EventsEmpty());
        return;
      }
      emit(EventsLoaded(events));
    });
  }
}
