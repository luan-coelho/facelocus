import 'package:facelocus/providers/event_provider.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => EventProvider())],
      child: const FaceLocusApplication()));
}

class FaceLocusApplication extends StatelessWidget {
  const FaceLocusApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Validação de presença",
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: AppConst.blue, foregroundColor: Colors.white),
          colorScheme: ColorScheme.fromSeed(
              seedColor: AppConst.blue, background: AppConst.white),
          useMaterial3: true,
          fontFamily: "Inter"),
      debugShowCheckedModeBanner: false,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
