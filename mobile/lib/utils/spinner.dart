import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 90,
      child: LoadingIndicator(
          indicatorType: Indicator.pacman,
          colors: [AppColorsConst.blue],
          strokeWidth: 2,
          backgroundColor: Colors.transparent,
          pathBackgroundColor: Colors.black),
    );
  }
}
