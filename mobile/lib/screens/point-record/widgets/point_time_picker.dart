import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/screens/point-record/point_record_create_screen.dart';
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
        TimePickerCard(
            dateTime: widget.point.finalDate,
            borderPosition: AxisDirection.right),
        Flexible(
          child: GestureDetector(
            onTap: removePoint,
            child: Container(
              padding: const EdgeInsets.all(5),
              height: 35,
              decoration: BoxDecoration(
                  color: Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, 1.5),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
