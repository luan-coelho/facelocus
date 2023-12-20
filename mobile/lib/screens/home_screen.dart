import 'package:flutter/material.dart';
import 'package:mobile/widgets/feature_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Facelocus", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF003C84)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 50, right: 50),
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 20);
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return const FeatureCard(
                    description: "Registros de ponto",
                    route: "",
                    color: Color(0xFF003C84),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
