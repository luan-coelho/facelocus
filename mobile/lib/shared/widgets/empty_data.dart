import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyData extends StatelessWidget {
  final String text;

  const EmptyData(this.text, {super.key});

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
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
