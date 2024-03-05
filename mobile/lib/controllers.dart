import 'package:facelocus/controllers/auth/register_controller.dart';
import 'package:facelocus/controllers/auth/session_controller.dart';
import 'package:facelocus/controllers/event_controller.dart';
import 'package:facelocus/controllers/location_controller.dart';
import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:facelocus/controllers/event_request_controller.dart';
import 'package:facelocus/controllers/point_record_show_controller.dart';
import 'package:facelocus/controllers/user_controller.dart';
import 'package:facelocus/services/auth_service.dart';
import 'package:facelocus/services/event_service.dart';
import 'package:facelocus/services/location_service.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:facelocus/services/event_request_service.dart';
import 'package:facelocus/services/user_attendance_service.dart';
import 'package:facelocus/services/user_service.dart';
import 'package:get/get.dart';

class AppControllers {
  static void initControllers() {
    Get.put(SessionController(service: AuthService()));
    Get.put(RegisterController(service: AuthService()));
    Get.put(EventController(service: EventService()));
    Get.put(EventRequestController(service: EventRequestService()));
    Get.put(UserController(service: UserService()));
    Get.put(PointRecordController(service: PointRecordService()));
    Get.put(PointRecordShowController(service: UserAttendanceService()));
    Get.put(LocationController(service: LocationService()));
  }
}
