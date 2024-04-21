import 'package:flutter/material.dart';

class AppDeleteButton extends StatefulWidget {
  const AppDeleteButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final bool? isLoading;

  @override
  State<AppDeleteButton> createState() => _AppDeleteButtonState();
}

class _AppDeleteButtonState extends State<AppDeleteButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.0,
      width: 25.0,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        onPressed: widget.onPressed,
        icon: widget.isLoading != null && widget.isLoading!
            ? const SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : const Icon(Icons.delete, size: 20.0),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        ),
      ),
    );
  }
}
