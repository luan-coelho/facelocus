import 'package:facelocus/features/event-request/repositories/event_request_service.dart';
import 'package:facelocus/features/event/repositories/event_repository.dart';
import 'package:facelocus/services/auth_repository.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthRepository());
  locator.registerLazySingleton(() => SessionRepository());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => EventRepository());
  locator.registerLazySingleton(() => EventRequestRepository());
  locator.registerLazySingleton(() => PointRecordRepository());
}
