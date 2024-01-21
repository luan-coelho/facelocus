import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/controllers/event_controller.dart';
import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:facelocus/controllers/ticket_request_controller.dart';
import 'package:facelocus/controllers/user_controller.dart';
import 'package:facelocus/services/auth_service.dart';
import 'package:facelocus/services/event_service.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:facelocus/services/ticket_request_service.dart';
import 'package:facelocus/services/user_service.dart';
import 'package:get/get.dart';

class AppControllers {
  static void initControllers() {
    Get.put(AuthController(service: AuthService()));
    Get.put(EventController(service: EventService()));
    Get.put(TicketRequestController(service: TicketRequestService()));
    Get.put(UserController(service: UserService()));
    Get.put(PointRecordController(service: PointRecordService()));
  }
}
