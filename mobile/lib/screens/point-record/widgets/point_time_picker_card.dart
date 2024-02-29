import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointTimePickerCard extends StatefulWidget {
  const PointTimePickerCard({super.key, required this.borderPosition});

  final AxisDirection borderPosition;

  @override
  State<PointTimePickerCard> createState() => _PointTimePickerCardState();
}

class _PointTimePickerCardState extends State<PointTimePickerCard> {
  late final PointRecordController _controller;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    _controller = Get.find<PointRecordController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: GestureDetector(
        onTap: () async {
          final TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: selectedTime ?? TimeOfDay.now(),
            initialEntryMode: TimePickerEntryMode.dial,
            orientation: Orientation.portrait,
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      alwaysUse24HourFormat: false,
                    ),
                    child: child!,
                  ),
                ),
              );
            },
          );
          DateTime dateTime = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              time!.hour,
              time.minute);
          if (widget.borderPosition == AxisDirection.left) {
            _controller.initialDate.value = dateTime;
          } else {
            _controller.finalDate.value = dateTime;
          }
          setState(() {
            selectedTime = time;
            final now = DateTime.now();
            if (selectedTime != null &&
                widget.borderPosition == AxisDirection.left) {
              DateTime initialDate = DateTime(
                  now.year, now.month, now.day, time.hour, time.minute);
              _controller.initialDate.value = initialDate;
            }

            if (selectedTime != null &&
                widget.borderPosition == AxisDirection.right) {
              DateTime finalDate = DateTime(
                  now.year, now.month, now.day, time.hour, time.minute);
              _controller.finalDate.value = finalDate;
            }
          });
        },
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                width: 110,
                height: 35,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedTime != null
                          ? selectedTime!.format(context)
                          : '---',
                      style: const TextStyle(fontSize: 18),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
