import 'package:face_camera/face_camera.dart';
import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/controllers/event_controller.dart';
import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:facelocus/controllers/ticket_request_controller.dart';
import 'package:facelocus/controllers/user_controller.dart';
import 'package:facelocus/providers/location_provider.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/services/auth_service.dart';
import 'package:facelocus/services/event_service.dart';
import 'package:facelocus/services/ticket_request_service.dart';
import 'package:facelocus/services/user_service.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  getControllers();

  WidgetsFlutterBinding.ensureInitialized(); //Add this
  await FaceCamera.initialize();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LocationProvider()),
  ], child: const FaceLocusApp()));
}

void getControllers() {
  Get.put(AuthController(service: AuthService()));
  Get.put(EventController(service: EventService()));
  Get.put(TicketRequestController(service: TicketRequestService()));
  Get.put(UserController(service: UserService()));
  Get.put(PointRecordController(service: UserService()));
}

class FaceLocusApp extends StatelessWidget {
  const FaceLocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: 'Validação de presença',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: AppColorsConst.blue,
              foregroundColor: Colors.white),
          colorScheme: ColorScheme.fromSeed(
              seedColor: AppColorsConst.blue, background: AppColorsConst.white),
          useMaterial3: true,
          fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
