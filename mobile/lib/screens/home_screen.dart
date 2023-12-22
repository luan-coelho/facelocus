import 'package:flutter/material.dart';
import 'package:mobile/widgets/feature_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const options = [
      FeatureCard(
          description: "Registros de ponto",
          route: "/point-record",
          color: Colors.white,
          backgroundColor: Color(0xFF003C84),
          imageName: "point-record-icon.svg"),
      FeatureCard(
          description: "Eventos",
          route: "/event",
          color: Colors.black,
          backgroundColor: Color(0xFFFFFFFF),
          imageName: "event-icon.svg"),
      FeatureCard(
          description: "Solicitações de ingresso",
          route: "/ticket-request",
          color: Colors.black,
          backgroundColor: Color(0xFFFAB411),
          imageName: "ticket-request-icon.svg")
    ];

    return Scaffold(
      appBar: AppBar(
          title: const Text("Facelocus")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListView.separated(
              padding: const EdgeInsets.only(left: 30, right: 30),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 20);
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                FeatureCard option = options[index];
                return FeatureCard(
                  description: option.description,
                  route: option.route,
                  color: option.color,
                  backgroundColor: option.backgroundColor,
                  imageName: option.imageName,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
