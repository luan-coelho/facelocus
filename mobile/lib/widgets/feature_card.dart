import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class FeatureCard extends StatelessWidget {
  final String description;
  final String route;
  final Color color;
  final Color backgroundColor;
  final String imageName;

  const FeatureCard(
      {super.key,
      required this.description,
      required this.route,
      required this.color,
      required this.backgroundColor,
      required this.imageName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {context.go(route)},
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 1.5), // Shadow position
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'images/$imageName',
                width: 50,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                    color: color, fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
