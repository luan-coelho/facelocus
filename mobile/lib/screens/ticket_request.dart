import 'package:flutter/material.dart';
import 'package:facelocus/constants.dart';
import 'package:facelocus/widgets/feature_card.dart';

class TicketRequestScreen extends StatelessWidget {
  const TicketRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const options = [
      FeatureCard(
          description: "Enviadas",
          route: "/point-record",
          color: Colors.white,
          backgroundColor: AppConst.primary,
          imageName: "sent-icon.svg"),
      FeatureCard(
          description: "Recebidas",
          route: "/event",
          color: Colors.black,
          backgroundColor: Colors.white,
          imageName: "received-icon.svg")];

    return Scaffold(
      appBar: AppBar(
          title: const Text("Solicitações")),
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
