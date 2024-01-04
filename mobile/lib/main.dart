import 'package:flutter/material.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Validação de presença',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: AppConst.blue, foregroundColor: Colors.white),
          colorScheme: ColorScheme.fromSeed(
              seedColor: AppConst.blue, background: AppConst.white),
          useMaterial3: true,
          fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
