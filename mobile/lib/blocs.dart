import 'package:facelocus/features/auth/blocs/login/login_bloc.dart';
import 'package:facelocus/features/auth/blocs/register/register_bloc.dart';
import 'package:facelocus/features/event-request/blocs/event-request-list/event_request_list_bloc.dart';
import 'package:facelocus/features/event-request/blocs/event-request-show/event_request_show_bloc.dart';
import 'package:facelocus/features/event-request/repositories/event_request_service.dart';
import 'package:facelocus/features/event/blocs/event-create/event_create_bloc.dart';
import 'package:facelocus/features/event/blocs/event-list/event_list_bloc.dart';
import 'package:facelocus/features/event/blocs/event-show/event_show_bloc.dart';
import 'package:facelocus/features/event/repositories/event_repository.dart';
import 'package:facelocus/features/home/bloc/home/home_bloc.dart';
import 'package:facelocus/services/auth_repository.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/shared/user-face-photo/user_face_photo_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocs {
  static final blocs = [
    BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(
        authRepository: AuthRepository(),
      ),
    ),
    BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(
        pointRecordRepository: PointRecordRepository(),
        sessionRepository: SessionRepository(),
      ),
    ),
    BlocProvider<UserFacePhotoBloc>(
      create: (context) => UserFacePhotoBloc(
        userRepository: UserRepository(),
        sessionRepository: SessionRepository(),
      ),
    ),
    BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(
        authRepository: AuthRepository(),
        userRepository: UserRepository(),
        sessionRepository: SessionRepository(),
        userFacePhotoBloc: BlocProvider.of<UserFacePhotoBloc>(context),
      ),
    ),
    BlocProvider<EventListBloc>(
      create: (context) => EventListBloc(
        eventRepository: EventRepository(),
        sessionRepository: SessionRepository(),
      ),
    ),
    BlocProvider<EventCreateBloc>(
      create: (context) => EventCreateBloc(
        eventRepository: EventRepository(),
        sessionRepository: SessionRepository(),
        eventListBloc: BlocProvider.of<EventListBloc>(context),
      ),
    ),
    BlocProvider<EventShowBloc>(
      create: (context) => EventShowBloc(
        eventRepository: EventRepository(),
      ),
    ),
    BlocProvider<EventRequestListBloc>(
      create: (context) => EventRequestListBloc(
        eventRequestRepository: EventRequestRepository(),
        sessionRepository: SessionRepository(),
      ),
    ),
    BlocProvider<EventRequestShowBloc>(
      create: (context) => EventRequestShowBloc(
        eventRequestRepository: EventRequestRepository(),
        sessionRepository: SessionRepository(),
      ),
    ),
  ];
}
