import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/dtos/create_ticket_request_dto.dart';
import 'package:facelocus/dtos/event_request_create_dto.dart';
import 'package:facelocus/dtos/user_with_id_only_dto.dart';
import 'package:facelocus/features/event-request/repositories/event_request_service.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'event_request_create_event.dart';
part 'event_request_create_state.dart';

class EventRequestCreateBloc
    extends Bloc<EventRequestCreateEvent, EventRequestCreateState> {
  final EventRequestRepository eventRequestRepository;
  final SessionRepository sessionRepository;

  EventRequestCreateBloc(
      {required this.eventRequestRepository, required this.sessionRepository})
      : super(EventRequestCreateInitial()) {
    on<CreateTicketRequest>((event, emit) async {
      try {
        emit(TicketRequestCreateLoading());
        UserModel user = sessionRepository.getUser()!;
        EventWithCodeDTO eventDto = EventWithCodeDTO(code: event.code);
        UserWithIdOnly initiatorUser = UserWithIdOnly(id: user.id);
        var eventRequest = CreateInvitationDTO(
          event: eventDto,
          initiatorUser: initiatorUser,
        );
        await eventRequestRepository.createTicketRequest(eventRequest);
        emit(TicketRequestCreateSuccess());
      } on DioException catch (e) {
        emit(TicketRequestCreateError(ResponseApiMessage.buildMessage(e)));
      }
    });
  }
}
