import 'dart:ui';

import 'package:face_camera/face_camera.dart';
import 'package:facelocus/blocs.dart';
import 'package:facelocus/controllers.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/service_locator.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

void main() async {
  setupLocator();
  AppControllers.initControllers();
  WidgetsFlutterBinding.ensureInitialized(); //Add this
  await FaceCamera.initialize();
  runApp(const FaceLocusApp());
}

class FaceLocusApp extends StatelessWidget {
  const FaceLocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocs.blocs,
      child: GetMaterialApp.router(
        title: 'Validação de presença',
        theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: 1.0,
                fontSizeDelta: 1.5,
                fontFamily: 'Poppins',
              ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColorsConst.dark,
            shadowColor: Colors.white,
            foregroundColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColorsConst.blue,
            onBackground: Colors.white,
            background: AppColorsConst.white,
          ),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        debugShowCheckedModeBanner: false,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('pt', 'BR'),
        ],
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: PointerDeviceKind.values.toSet(),
        ),
      ),
    );
  }
}
