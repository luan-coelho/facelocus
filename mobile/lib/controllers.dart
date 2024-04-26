import 'package:facelocus/controllers/event_request_controller.dart';
import 'package:facelocus/controllers/location_controller.dart';
import 'package:facelocus/controllers/point_record_create_controller.dart';
import 'package:facelocus/controllers/point_record_edit_controller.dart';
import 'package:facelocus/controllers/point_record_show_controller.dart';
import 'package:facelocus/controllers/user_controller.dart';
import 'package:facelocus/controllers/validate_point_controller.dart';
import 'package:facelocus/features/event-request/repositories/event_request_service.dart';
import 'package:facelocus/services/location_service.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:facelocus/services/user_attendance_service.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:get/get.dart';

class AppControllers {
  static void initControllers() {
    Get.put(EventRequestController(service: EventRequestRepository()));
    Get.put(UserController(service: UserRepository()));
    Get.put(PointRecordCreateController(service: PointRecordRepository()));
    Get.put(PointRecordEditController(service: PointRecordRepository()));
    Get.put(PointRecordShowController(service: UserAttendanceService()));
    Get.put(LocationController(service: LocationService()));
    Get.put(ValidatePointController(service: PointRecordRepository()));
  }
}
