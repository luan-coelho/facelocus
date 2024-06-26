import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyData extends StatelessWidget {
  const EmptyData(
    this.text, {
    super.key,
    this.child,
    this.actionButton,
  });

  final String text;
  final Widget? child;
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'images/empty.svg',
            width: 300,
          ),
          const SizedBox(height: 25),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis),
          SizedBox(height: child != null ? 25 : 0),
          child != null ? child! : const SizedBox(),
          SizedBox(height: actionButton != null ? 25 : 0),
        ],
      ),
    );
  }
}
