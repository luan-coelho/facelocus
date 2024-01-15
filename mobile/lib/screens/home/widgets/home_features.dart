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
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: const [
          FeatureCard(
              description: "Registros de ponto",
              route: "/point-record",
              color: Colors.white,
              backgroundColor: AppColorsConst.blue,
              imageName: "point-record-icon.svg",
              expanded: false),
          FeatureCard(
            description: "Eventos",
            route: "/event",
            color: Colors.black,
            backgroundColor: Colors.white,
            imageName: "event-icon.svg",
            expanded: false,
          ),
          // Adicione mais FeatureCards conforme necessário
        ],
      ),
    );
  }
}
