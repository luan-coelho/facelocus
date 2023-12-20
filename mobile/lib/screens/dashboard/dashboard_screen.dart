import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/widgets/app_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Dashboard de validação",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            Button(
                text: "Navegar para home",
                onPressed: () {
                  context.go("/");
                })
          ],
        ),
      ),
    );
  }
}
