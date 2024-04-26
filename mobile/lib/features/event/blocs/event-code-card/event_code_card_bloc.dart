import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/features/event/blocs/event-show/event_show_bloc.dart';
import 'package:facelocus/features/event/repositories/event_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'event_code_card_event.dart';
part 'event_code_card_state.dart';

class EventCodeCardBloc extends Bloc<EventCodeCardEvent, EventCodeCardState> {
  final EventRepository eventRepository;
  final EventShowBloc eventShowBloc;

  EventCodeCardBloc({
    required this.eventRepository,
    required this.eventShowBloc,
  }) : super(EventCodeCardInitial()) {
    on<GenerateNewCode>((event, emit) async {
      try {
        emit(EventCodeCardLoading());
        eventRepository.generateNewCode(event.id);
        eventShowBloc.add(LoadEvent(event.id));
      } on DioException catch (e) {
        emit(EventCodeCardError(ResponseApiMessage.buildMessage(e)));
      }
    });

    on<CodeCopied>((event, emit) {
      emit(CodeCopiedSuccess(event.code));
    });
  }
}
