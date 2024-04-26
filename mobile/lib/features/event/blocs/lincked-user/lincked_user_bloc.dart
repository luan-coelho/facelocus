import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'lincked_user_event.dart';
part 'lincked_user_state.dart';

class LinckedUserBloc extends Bloc<LinckedUserEvent, LinckedUserState> {
  LinckedUserBloc() : super(LinckedUserInitial()) {
    on<LinckedUserEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
