import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField(
      {super.key,
      this.labelText,
      required this.textEditingController,
      this.validator,
      this.onSaved});

  final String? labelText;
  final TextEditingController textEditingController;
  final FormFieldValidator? validator;
  final FormFieldSetter? onSaved;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      widget.labelText != null
          ? Text(widget.labelText!,
              style: const TextStyle(fontWeight: FontWeight.w500))
          : const SizedBox(),
      const SizedBox(height: 5),
      TextFormField(
        controller: widget.textEditingController,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(5.0),
            )),
        validator: widget.validator,
        onSaved: widget.onSaved,
      ),
    ]);
  }
}
