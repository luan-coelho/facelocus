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
import 'package:facelocus/services/auth_repository.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/shared/user-face-photo/user_face_photo_bloc.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // Repositórios
  locator.registerLazySingleton(() => AuthRepository());
  locator.registerLazySingleton(() => SessionRepository());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => EventRepository());
  locator.registerLazySingleton(() => EventRequestRepository());
  locator.registerLazySingleton(() => PointRecordRepository());

  // Blocs
  locator.registerFactory(() => RegisterBloc(
        authRepository: locator<AuthRepository>(),
      ));
  locator.registerFactory(() => HomeBloc(
        pointRecordRepository: locator<PointRecordRepository>(),
        sessionRepository: locator<SessionRepository>(),
      ));
  locator.registerFactory(() => UserFacePhotoBloc(
        userRepository: locator<UserRepository>(),
        sessionRepository: locator<SessionRepository>(),
      ));
  locator.registerFactory(() => LoginBloc(
        authRepository: locator<AuthRepository>(),
        userRepository: locator<UserRepository>(),
        sessionRepository: locator<SessionRepository>(),
        userFacePhotoBloc: locator<UserFacePhotoBloc>(),
      ));
  locator.registerFactory(() => EventListBloc(
        eventRepository: locator<EventRepository>(),
        sessionRepository: locator<SessionRepository>(),
      ));
  locator.registerFactory(() => EventCreateBloc(
        eventRepository: locator<EventRepository>(),
        sessionRepository: locator<SessionRepository>(),
        eventListBloc: locator<EventListBloc>(),
      ));
  locator.registerFactory(() => EventShowBloc(
        eventRepository: locator<EventRepository>(),
      ));
  locator.registerFactory(() => EventRequestListBloc(
        eventRequestRepository: locator<EventRequestRepository>(),
        sessionRepository: locator<SessionRepository>(),
      ));
  locator.registerFactory(() => EventRequestShowBloc(
        eventRequestRepository: locator<EventRequestRepository>(),
        sessionRepository: locator<SessionRepository>(),
      ));
  locator.registerFactory(() => EventCodeCardBloc(
        eventRepository: locator<EventRepository>(),
        eventShowBloc: locator<EventShowBloc>(),
      ));
  locator.registerFactory(() => FaceUploudBloc(
        userRepository: locator<UserRepository>(),
        sessionRepository: locator<SessionRepository>(),
      ));
  locator.registerFactory(() => LinckedUserBloc());
  locator.registerFactory(
    () => LinckedUsersBloc(
      userRepository: locator<UserRepository>(),
    ),
  );
}
