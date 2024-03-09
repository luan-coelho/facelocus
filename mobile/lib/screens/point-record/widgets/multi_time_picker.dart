import 'package:facelocus/controllers/point_record_create_controller.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/screens/point-record/widgets/time_picker.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_delete_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MultiTimePicker extends StatefulWidget {
  const MultiTimePicker({super.key});

  @override
  State<StatefulWidget> createState() => _MultiTimePickerState();
}

class _MultiTimePickerState extends State<MultiTimePicker> {
  late final PointRecordCreateController _controller;
  DateTime dateTime = DateTime.now();
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  List<Map<String, TimeOfDay>> timeIntervals = [];

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  TimeOfDay addMinutes(TimeOfDay originalTime, int minutesToAdd) {
    int totalMinutes = originalTime.minute + minutesToAdd;
    int extraHours = totalMinutes ~/ 60;
    int newMinute = totalMinutes % 60;
    int newHour = (originalTime.hour + extraHours) % 24;

    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  void _addInterval() {
    final DateTime now = DateTime.now();
    DateTime initialDate = DateTime(
        now.year, now.month, now.day, _startTime.hour, _startTime.minute);
    DateTime finalDate =
        DateTime(now.year, now.month, now.day, _endTime.hour, _endTime.minute);
    PointModel point =
        PointModel(initialDate: initialDate, finalDate: finalDate);
    _controller.points.add(point);
    setState(() {
      timeIntervals.add({'initialDate': _startTime, 'finalDate': _endTime});
      _startTime = addMinutes(_endTime, 15);
      _endTime = addMinutes(_startTime, 15);
    });
  }

  void _removeInterval(int index) {
    _controller.points.removeAt(index);
    setState(() {
      timeIntervals.removeAt(index);
    });
  }

  @override
  void initState() {
    _controller = Get.find<PointRecordCreateController>();
    _startTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    DateTime endTime = dateTime.add(const Duration(minutes: 15));
    _endTime = TimeOfDay(hour: endTime.hour, minute: endTime.minute);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TimePicker(
                description: 'Hora inicial',
                timeOfDay: _startTime,
                onTap: () => _selectTime(context, true),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: TimePicker(
                description: 'Hora final',
                timeOfDay: _endTime,
                onTap: () => _selectTime(context, false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: AppButton(
            onPressed: _addInterval,
            textColor: Colors.green,
            text: 'Adicionar intervalo',
            height: 50,
            textFontSize: 14,
            borderColor: Colors.green,
            backgroundColor: Colors.green.withOpacity(0.2),
          ),
        ),
        const SizedBox(height: 10),
        if (_controller.points.isNotEmpty)
          const Column(
            children: [
              Text('Intervalos', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
            ],
          ),
        const SizedBox(),
        Obx(() {
          return ListView.separated(
            shrinkWrap: true,
            itemCount: _controller.points.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 5);
            },
            itemBuilder: (context, index) {
              final PointModel point = _controller.points[index];
              return Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  width: double.infinity,
                  height: 45,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timelapse, color: Colors.black),
                          const SizedBox(width: 5),
                          Builder(builder: (context) {
                            final DateFormat formatter = DateFormat('HH:mm');
                            final String initialDate =
                                formatter.format(point.initialDate);
                            var finalDate = formatter.format(point.finalDate);
                            return Text('$initialDate - $finalDate',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300));
                          }),
                        ],
                      ),
                      AppDeleteButton(onPressed: () => _removeInterval(index))
                    ],
                  )));
            },
          );
        }),
      ],
    );
  }
}
