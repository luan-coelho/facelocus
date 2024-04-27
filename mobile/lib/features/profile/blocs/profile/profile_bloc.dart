import 'package:bloc/bloc.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:flutter/material.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  SessionRepository sessionRepository;

  ProfileBloc({
    required this.sessionRepository,
  }) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      var user = await sessionRepository.getUser();
      emit(ProfileLoaded(authenticatedUserFullName: user!.getFullName()));
    });

    on<Logout>((event, emit) async {
      await sessionRepository.logout();
      emit(LogoutSuccess());
    });
  }
}
