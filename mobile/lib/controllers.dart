import 'package:facelocus/controllers/location_controller.dart';
import 'package:facelocus/controllers/point_record_edit_controller.dart';
import 'package:facelocus/services/location_repository.dart';
import 'package:facelocus/services/point_record_repository.dart';
import 'package:get/get.dart';

class AppControllers {
  static void initControllers() {
    Get.put(PointRecordEditController(service: PointRecordRepository()));
    Get.put(LocationController(service: LocationRepository()));
  }
}
