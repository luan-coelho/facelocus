import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/screens/point-record/point_record_create_screen.dart';
import 'package:facelocus/shared/widgets/app_delete_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointTimePicker extends StatefulWidget {
  const PointTimePicker({super.key, required this.point});

  final PointModel point;

  @override
  State<PointTimePicker> createState() => _PointTimePickerState();
}

class _PointTimePickerState extends State<PointTimePicker> {
  late final PointRecordController _controller;

  @override
  void initState() {
    _controller = Get.find<PointRecordController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    removePoint() {
      _controller.points.remove(widget.point);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TimePickerCard(
            dateTime: widget.point.initialDate,
            borderPosition: AxisDirection.left),
        const SizedBox(
          width: 10,
        ),
        AppDeleteButton(onPressed: removePoint),
        const SizedBox(
          width: 10,
        ),
        TimePickerCard(
            dateTime: widget.point.finalDate,
            borderPosition: AxisDirection.right)
      ],
    );
  }
}
