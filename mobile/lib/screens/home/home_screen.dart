import 'package:facelocus/router.dart';
import 'package:facelocus/screens/home/widgets/home_features.dart';
import 'package:facelocus/screens/home/widgets/user_card.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
        showAppBar: false,
        body: const Padding(
          padding: EdgeInsets.only(top: 50, bottom: 20, left: 32, right: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserCardHome(),
              SizedBox(height: 30),
              HomeFeatures(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(AppRoutes.pointRecordCreate),
          backgroundColor: Colors.green,
          child: const Icon(Icons.add, color: Colors.white, size: 29),
        ));
  }
}
