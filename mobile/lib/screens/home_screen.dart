import 'package:facelocus/constants.dart';
import 'package:flutter/material.dart';
import 'package:facelocus/widgets/feature_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FeatureCard(
              description: "Registros de ponto",
              route: "/point-record",
              color: Colors.white,
              backgroundColor: AppConst.blue,
              imageName: "point-record-icon.svg",
            ),
            SizedBox(height: 20),
            FeatureCard(
              description: "Eventos",
              route: "/event",
              color: Colors.black,
              backgroundColor: Colors.white,
              imageName: "event-icon.svg",
            ),
            SizedBox(height: 20),
            FeatureCard(
              description: "Solicitações de ingresso",
              route: "/ticket-request",
              color: Colors.black,
              backgroundColor: AppConst.yellow,
              imageName: "ticket-request-icon.svg",
            ),
          ],
        ),
      ),
    );
  }
}
