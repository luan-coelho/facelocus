import 'package:facelocus/delegates/blocs/lincked-users-delegate/lincked_users_delegate_bloc.dart';
import 'package:facelocus/features/auth/blocs/face-uploud/face_uploud_bloc.dart';
import 'package:facelocus/features/auth/blocs/login/login_bloc.dart';
import 'package:facelocus/features/auth/blocs/register/register_bloc.dart';
import 'package:facelocus/features/event-request/blocs/event-request-list/event_request_list_bloc.dart';
import 'package:facelocus/features/event-request/blocs/event-request-show/event_request_show_bloc.dart';
import 'package:facelocus/features/event-request/repositories/event_request_service.dart';
import 'package:facelocus/features/event/blocs/event-code-card/event_code_card_bloc.dart';
import 'package:facelocus/features/event/blocs/event-create/event_create_bloc.dart';
import 'package:facelocus/features/event/blocs/event-list/event_list_bloc.dart';
import 'package:facelocus/features/event/blocs/event-show/event_show_bloc.dart';
import 'package:facelocus/features/event/blocs/lincked-user/lincked_user_bloc.dart';
import 'package:facelocus/features/event/blocs/lincked-users/lincked_users_bloc.dart';
import 'package:facelocus/features/event/repositories/event_repository.dart';
import 'package:facelocus/features/home/bloc/home/home_bloc.dart';
import 'package:facelocus/service_locator.dart';
import 'package:facelocus/services/auth_repository.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/shared/user-face-photo/user_face_photo_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocs {
  static final blocs = [
    BlocProvider<UserFacePhotoBloc>(
      create: (context) => UserFacePhotoBloc(
        userRepository: locator<UserRepository>(),
        sessionRepository: locator<SessionRepository>(),
      ),
    ),
    BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(
        authRepository: locator<AuthRepository>(),
        userRepository: locator<UserRepository>(),
        sessionRepository: locator<SessionRepository>(),
        userFacePhotoBloc: BlocProvider.of<UserFacePhotoBloc>(context),
      ),
    ),
    BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(
        authRepository: locator<AuthRepository>(),
      ),
    ),
    BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(
        pointRecordRepository: locator<PointRecordRepository>(),
        sessionRepository: locator<SessionRepository>(),
      ),
    ),
    BlocProvider<EventListBloc>(
      create: (context) => EventListBloc(
        eventRepository: locator<EventRepository>(),
        sessionRepository: locator<SessionRepository>(),
      ),
    ),
    BlocProvider<EventCreateBloc>(
      create: (context) => EventCreateBloc(
        eventRepository: locator<EventRepository>(),
        sessionRepository: locator<SessionRepository>(),
        eventListBloc: BlocProvider.of<EventListBloc>(context),
      ),
    ),
    BlocProvider<EventShowBloc>(
      create: (context) => EventShowBloc(
        eventRepository: locator<EventRepository>(),
      ),
    ),
    BlocProvider<EventRequestListBloc>(
      create: (context) => EventRequestListBloc(
        eventRequestRepository: locator<EventRequestRepository>(),
        sessionRepository: locator<SessionRepository>(),
      ),
    ),
    BlocProvider<EventRequestShowBloc>(
      create: (context) => EventRequestShowBloc(
        eventRequestRepository: locator<EventRequestRepository>(),
        sessionRepository: locator<SessionRepository>(),
      ),
    ),
    BlocProvider<EventCodeCardBloc>(
      create: (context) => EventCodeCardBloc(
        eventRepository: locator<EventRepository>(),
        eventShowBloc: BlocProvider.of<EventShowBloc>(context),
      ),
    ),
    BlocProvider<FaceUploudBloc>(
      create: (context) => FaceUploudBloc(
        userRepository: locator<UserRepository>(),
        sessionRepository: locator<SessionRepository>(),
      ),
    ),
    BlocProvider<LinckedUserBloc>(
      create: (context) => LinckedUserBloc(),
    ),
    BlocProvider<LinckedUsersBloc>(
      create: (context) => LinckedUsersBloc(
        userRepository: locator<UserRepository>(),
      ),
    ),
    BlocProvider<LinckedUsersDelegateBloc>(
      create: (context) => LinckedUsersDelegateBloc(
        userRepositoy: locator<UserRepository>(),
        eventRequestRepository: locator<EventRequestRepository>(),
        sessionRepository: locator<SessionRepository>(),
      ),
    ),
  ];
}
