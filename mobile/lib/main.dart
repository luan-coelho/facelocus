import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/controllers/event_controller.dart';
import 'package:facelocus/providers/location_provider.dart';
import 'package:facelocus/providers/user_provider.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/services/auth_service.dart';
import 'package:facelocus/services/event_service.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  Get.put(AuthController(service: AuthService()));
  Get.put(EventController(service: EventService()));
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LocationProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider())
  ], child: const FaceLocusApp()));
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
