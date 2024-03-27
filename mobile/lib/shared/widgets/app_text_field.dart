import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.labelText,
    required this.textEditingController,
    this.validator,
    this.onSaved,
    this.keyboardType = TextInputType.text,
    this.maxLength,
  });

  final String? labelText;
  final TextEditingController textEditingController;
  final FormFieldValidator? validator;
  final FormFieldSetter? onSaved;
  final TextInputType? keyboardType;
  final int? maxLength;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  @override
  void initState() {
    _obscured = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelText != null
            ? Text(
                widget.labelText!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              )
            : const SizedBox(),
        const SizedBox(height: 5),
        TextFormField(
          controller: widget.textEditingController,
          keyboardType: widget.keyboardType,
          obscureText: widget.keyboardType == TextInputType.visiblePassword
              ? _obscured
              : false,
          decoration: InputDecoration(
            counter: const Offstage(),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black38),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(10.0),
            ),
            suffixIcon: widget.keyboardType == TextInputType.visiblePassword
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: _toggleObscured,
                      child: Icon(
                        _obscured
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 24,
                      ),
                    ),
                  )
                : null,
          ),
          validator: widget.validator,
          onSaved: widget.onSaved,
          maxLength: widget.maxLength ?? 255,
          maxLengthEnforcement: null,
        ),
      ],
    );
  }
}
