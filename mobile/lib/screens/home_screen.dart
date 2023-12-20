import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/widgets/app_button.dart';
import 'package:mobile/widgets/app_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Validação")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Validação de presença",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Button(
                  text: "Navegar para dashboard",
                  onPressed: () {
                    context.go("/dashboard");
                  }),
            ),
            const Text("Cards",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(
              height: 200,
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 8),
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 12);
                },
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return const AppCard(text: "Teste");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
