import 'package:facelocus/features/event-request/repositories/event_request_service.dart';
import 'package:facelocus/features/event/repositories/event_repository.dart';
import 'package:facelocus/features/point-record/repositories/attendance_record_repository.dart';
import 'package:facelocus/services/auth_repository.dart';
import 'package:facelocus/services/point_record_repository.dart';
import 'package:facelocus/services/user_attendance_repository.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/shared/widgets/app_search_field.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  /*Repositórios*/
  locator.registerLazySingleton(() => AuthRepository());
  locator.registerLazySingleton(() => SessionRepository());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => EventRepository());
  locator.registerLazySingleton(() => EventRequestRepository());
  locator.registerLazySingleton(() => PointRecordRepository());
  locator.registerLazySingleton(() => UserAttendanceRepository());
  locator.registerLazySingleton(() => AttendanceRecordRepository());

  /*Tools*/
  locator.registerLazySingleton(() => Location());
  locator.registerLazySingleton(() => Debouncer());
}
