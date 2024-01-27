import 'package:flutter/material.dart';

class AppDeleteButton extends StatelessWidget {
  const AppDeleteButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.0,
      width: 25.0,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        onPressed: onPressed,
        icon: const Icon(Icons.delete, size: 20.0),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        ),
      ),
    );
  }
}
