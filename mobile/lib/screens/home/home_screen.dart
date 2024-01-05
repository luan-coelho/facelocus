import 'package:facelocus/screens/home/widgets/home_features.dart';
import 'package:facelocus/screens/home/widgets/user_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50, bottom: 20, left: 32, right: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserCardHome(),
            HomeFeatures(),
          ],
        ),
      ),
    );
  }
}
