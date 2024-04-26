import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UnexpectedError extends StatelessWidget {
  const UnexpectedError(
    this.text, {
    super.key,
    this.child,
    this.tryAgainButton,
  });

  final String text;
  final Widget? child;
  final Widget? tryAgainButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'images/error.svg',
            width: 300,
          ),
          const SizedBox(height: 25),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
          SizedBox(height: child != null ? 25 : 0),
          child != null ? child! : const SizedBox(),
          SizedBox(height: tryAgainButton != null ? 25 : 0),
          if (tryAgainButton != null) tryAgainButton!,
        ],
      ),
    );
  }
}
