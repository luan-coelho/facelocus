import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/feature_card.dart';
import 'package:flutter/material.dart';

class HomeFeatures extends StatelessWidget {
  const HomeFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: const [
          FeatureCard(
            description: "Registros de ponto",
            route: "/point-record",
            color: Colors.white,
            backgroundColor: AppConst.blue,
            imageName: "point-record-icon.svg",
          ),
          FeatureCard(
            description: "Eventos",
            route: "/event",
            color: Colors.black,
            backgroundColor: Colors.white,
            imageName: "event-icon.svg",
          ),
          FeatureCard(
            description: "Solicitações de ingresso",
            route: "/ticket-request",
            color: Colors.black,
            backgroundColor: AppConst.yellow,
            imageName: "ticket-request-icon.svg",
          ),
          // Adicione mais FeatureCards conforme necessário
        ],
      ),
    );
  }
}
