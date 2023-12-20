import 'package:flutter/material.dart';

class FVAppBar extends StatelessWidget {
  const FVAppBar({super.key});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120), // Set this height
      child: Container(
        color: Colors.orange,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('One'),
          ],
        ),
      ),
    );
  }
}
