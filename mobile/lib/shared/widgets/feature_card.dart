import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class FeatureCard extends StatelessWidget {
  final String description;
  final String route;
  final Color color;
  final Color backgroundColor;
  final String imageName;
  final double? width;
  final double? height;
  final bool expanded;

  const FeatureCard(
      {super.key,
      required this.description,
      required this.route,
      required this.color,
      required this.backgroundColor,
      required this.imageName,
      this.width,
      this.height,
      this.expanded = true});

  @override
  Widget build(BuildContext context) {
    GestureDetector cardChild() {
      return GestureDetector(
        onTap: () => {context.push(route)},
        child: Container(
          width: width ?? double.infinity,
          height: height ?? 130,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return expanded
        ? Expanded(
            child: cardChild(),
          )
        : cardChild();
  }
}
