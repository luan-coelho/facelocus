import 'package:facelocus/shared/widgets/feature_card.dart';
import 'package:flutter/material.dart';
import 'package:facelocus/shared/constants.dart';

class TicketRequestScreen extends StatelessWidget {
  const TicketRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Solicitações")),
      body: const Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FeatureCard(
                description: "Enviadas",
                route: "/point-record",
                color: Colors.white,
                backgroundColor: AppConst.blue,
                imageName: "sent-icon.svg"),
            SizedBox(height: 20),
            FeatureCard(
                description: "Recebidas",
                route: "/event",
                color: Colors.black,
                backgroundColor: Colors.white,
                imageName: "received-icon.svg")
          ],
        ),
      ),
    );
  }
}
