import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/dtos/create_ticket_request_dto.dart';
import 'package:facelocus/dtos/event_request_create_dto.dart';
import 'package:facelocus/dtos/user_with_id_only_dto.dart';
import 'package:facelocus/features/event-request/repositories/event_request_service.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'lincked_users_delegate_event.dart';
part 'lincked_users_delegate_state.dart';

class LinckedUsersDelegateBloc
    extends Bloc<LinckedUsersDelegateEvent, LinckedUsersDelegateState> {
  final UserRepository userRepositoy;
  final EventRequestRepository eventRequestRepository;
  final SessionRepository sessionRepository;

  LinckedUsersDelegateBloc({
    required this.userRepositoy,
    required this.eventRequestRepository,
    required this.sessionRepository,
  }) : super(LinckedUsersDelegateInitial()) {
    on<LoadAllUsers>(
      (event, emit) async {
        try {
          emit(LinckedUsersLoading());
          UserModel user = sessionRepository.getUser()!;
          var users = await userRepositoy.getAllByNameOrCpf(
            user.id!,
            event.query,
          );
          if (users.isEmpty) {
            emit(LinckedUsersEmpty());
            return;
          }
          emit(LinckedUsersLoaded(users: users));
        } on DioException catch (e) {
          emit(LinckedUsersError(ResponseApiMessage.buildMessage(e)));
        }
      },
    );

    on<CreateEnviation>(
      (event, emit) async {
        try {
          emit(CreateInvitationLoading());
          UserModel user = sessionRepository.getUser()!;
          EventWithCodeDTO eventDto = EventWithCodeDTO(id: event.eventId);
          UserWithIdOnly initiatorUser = UserWithIdOnly(id: user.id);
          UserWithIdOnly targetUser = UserWithIdOnly(id: event.userId);
          var eventRequest = CreateInvitationDTO(
            event: eventDto,
            initiatorUser: initiatorUser,
            targetUser: targetUser,
          );
          await eventRequestRepository.createInvitation(eventRequest);
          emit(CreateInvitationSuccess());
        } on DioException catch (e) {
          emit(LinckedUsersError(ResponseApiMessage.buildMessage(e)));
        }
      },
    );
  }
}
