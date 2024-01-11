import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  const AppButton(
      {super.key,
      required this.text,
      this.textColor,
      this.textFontSize,
      this.backgroundColor,
      this.onPressed,
      this.icon,
      this.isLoading = false});

  final String text;
  final Color? textColor;
  final double? textFontSize;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool? isLoading;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                widget.backgroundColor ?? AppColorsConst.blue),
            foregroundColor: MaterialStateProperty.all<Color>(
                widget.textColor ?? Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ))),
        onPressed: widget.isLoading != null ? widget.onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.isLoading != null && widget.isLoading!
                ? const SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(color: Colors.white))
                : (widget.icon ?? const SizedBox()),
            SizedBox(width: widget.icon != null || widget.isLoading! ? 10 : 0),
            Text(widget.text,
                style: TextStyle(
                    fontSize: widget.textFontSize ?? 14,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
