import 'package:flutter/material.dart';
import 'package:mobile/router.dart';

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
              backgroundColor: Color(0xFF003C84), foregroundColor: Colors.white),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF003C84),
              background: const Color(0xFFF1F2F6)),
          useMaterial3: true,
          fontFamily: 'Inter'),
      debugShowCheckedModeBanner: false,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
