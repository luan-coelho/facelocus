import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  const TimePicker(
      {super.key,
      required this.description,
      required this.timeOfDay,
      this.onTap});

  final String description;
  final TimeOfDay timeOfDay;
  final GestureTapCallback? onTap;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.black12.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: [
              Text(
                widget.description,
                style: const TextStyle(
                    color: AppColorsConst.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                widget.timeOfDay.format(context),
                style: const TextStyle(
                    color: AppColorsConst.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }
}
