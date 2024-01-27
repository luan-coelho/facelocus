import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  const AppButton(
      {super.key,
      this.text,
      this.textStyle,
      this.textColor,
      this.textFontSize,
      this.backgroundColor,
      this.borderColor,
      this.onPressed,
      this.icon,
      this.isLoading = false,
      this.width,
      this.height});

  final String? text;
  final TextStyle? textStyle;
  final Color? textColor;
  final double? textFontSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool? isLoading;
  final double? width;
  final double? height;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 40,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                widget.backgroundColor ?? AppColorsConst.purple),
            foregroundColor: MaterialStateProperty.all<Color>(
                widget.textColor ?? AppColorsConst.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              side: BorderSide(
                color: widget.borderColor != null
                    ? widget.borderColor!
                    : widget.backgroundColor ?? AppColorsConst.purple,
              ),
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
            widget.text != null
                ? Text(widget.text!,
                    style: widget.textStyle ??
                        TextStyle(
                            fontSize: widget.textFontSize ?? 14,
                            fontWeight: FontWeight.w600))
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
