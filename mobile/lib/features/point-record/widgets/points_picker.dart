import 'package:facelocus/features/point-record/widgets/time_picker.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_delete_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PointsPicker extends StatefulWidget {
  const PointsPicker({
    super.key,
    required this.onPointListChanged,
    this.value,
  });

  final ValueChanged<List<PointModel>> onPointListChanged;
  final List<PointModel>? value;

  @override
  State<StatefulWidget> createState() => _PointsPickerState();
}

class _PointsPickerState extends State<PointsPicker> {
  late final List<PointModel> _points;
  late DateTime _dateTime;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

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
    DateTime startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _startTime.hour,
      _startTime.minute,
    );
    DateTime endDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _endTime.hour,
      _endTime.minute,
    );
    PointModel point = PointModel(
      initialDate: startDateTime,
      finalDate: endDateTime,
    );
    setState(() {
      _startTime = addMinutes(_endTime, 15);
      _endTime = addMinutes(_startTime, 15);
      _points.add(point);
    });
    widget.onPointListChanged(_points);
  }

  void _removeInterval(int index) {
    setState(() {
      _points.removeAt(index);
      widget.onPointListChanged(_points);
    });
  }

  @override
  void initState() {
    _dateTime = DateTime.now();
    _startTime = TimeOfDay(hour: _dateTime.hour, minute: _dateTime.minute);
    DateTime endTime = _dateTime.add(const Duration(minutes: 15));
    _endTime = TimeOfDay(hour: endTime.hour, minute: endTime.minute);
    _points = widget.value ?? <PointModel>[];
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
        if (_points.isNotEmpty)
          const Column(
            children: [
              Text(
                'Intervalos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
            ],
          ),
        const SizedBox(),
        ListView.separated(
          shrinkWrap: true,
          itemCount: _points.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 5);
          },
          itemBuilder: (context, index) {
            final PointModel point = _points[index];
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
                          final idt = formatter.format(point.initialDate);
                          var fdt = formatter.format(point.finalDate);
                          return Text(
                            '$idt - $fdt',
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          );
                        }),
                      ],
                    ),
                    AppDeleteButton(
                      onPressed: () => _removeInterval(index),
                    )
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
