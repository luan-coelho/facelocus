import 'package:flutter/material.dart';
import 'package:facelocus/shared/constants.dart'; // Garanta que este import contém AppColorsConst

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    this.text,
    this.textStyle,
    this.textColor,
    this.textFontSize,
    this.backgroundColor,
    this.borderColor,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.disabled = false,
    this.width,
    this.height,
  });

  final String? text;
  final TextStyle? textStyle;
  final Color? textColor;
  final double? textFontSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool? isLoading;
  final bool disabled; // Adicionado novo campo disabled
  final double? width;
  final double? height;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = widget.disabled == true ||
        widget.isLoading == true ||
        widget.onPressed == null;
    final double opacity = isButtonDisabled ? 0.5 : 1.0;

    return Opacity(
      opacity: opacity,
      child: SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 50,
        child: TextButton(
          style: ButtonStyle(
            alignment: Alignment.center,
            padding:
                MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
            backgroundColor: MaterialStateProperty.all<Color>(
                widget.backgroundColor ?? AppColorsConst.purple),
            foregroundColor: MaterialStateProperty.all<Color>(
                widget.textColor ?? AppColorsConst.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              side: BorderSide(
                color: widget.borderColor ??
                    widget.backgroundColor ??
                    AppColorsConst.purple,
              ),
              borderRadius: BorderRadius.circular(10.0),
            )),
          ),
          onPressed: isButtonDisabled ? null : widget.onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.isLoading == true)
                const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              else
                widget.icon ?? const SizedBox(),
              SizedBox(
                  width:
                      widget.icon != null || widget.isLoading == true ? 10 : 0),
              widget.text != null
                  ? Text(widget.text!,
                      style: widget.textStyle ??
                          TextStyle(
                            fontSize: widget.textFontSize ?? 14,
                            fontWeight: FontWeight.w600,
                          ))
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
