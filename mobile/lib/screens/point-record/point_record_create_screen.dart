import 'dart:collection';

import 'package:facelocus/controllers/event_controller.dart';
import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/screens/point-record/widgets/point_time_picker.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_date_picker.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointRecordCreateScreen extends StatefulWidget {
  const PointRecordCreateScreen({super.key});

  @override
  State<PointRecordCreateScreen> createState() =>
      _PointRecordCreateScreenState();
}

class _PointRecordCreateScreenState extends State<PointRecordCreateScreen> {
  late final PointRecordController _controller;
  late final EventController _eventController;
  bool faceRecognitionFactor = false;
  bool indoorLocationFactor = false;
  double _allowableRadiusInMeters = 5.0;
  late final RestorableDateTime _date;
  late PointModel _point;
  List<PointModel> points = [];
  HashSet<Factor> factors = HashSet();

  _create() {
    if (faceRecognitionFactor) {
      factors.add(Factor.facialRecognition);
    }
    if (indoorLocationFactor) {
      factors.add(Factor.indoorLocation);
    }
    PointRecordModel pointRecord = PointRecordModel(
      event: _eventController.event,
      date: _controller.date.value ?? DateTime.now(),
      points: _controller.points,
      factors: factors.toList(),
      allowableRadiusInMeters: _allowableRadiusInMeters,
    );
    _controller.create(context, pointRecord);
  }

  @override
  void initState() {
    _controller = Get.find<PointRecordController>();
    _eventController = Get.find<EventController>();
    _eventController.fetchById(1);
    _date = RestorableDateTime(DateTime.now());
    _point = PointModel(initialDate: DateTime.now(), finalDate: DateTime.now());
    super.initState();
  }

  @override
  void dispose() {
    _controller.cleanPoints();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    newPoint() {
      DateTime initialDate = DateTime.now();
      DateTime finalDate = DateTime.now();
      _point = PointModel(initialDate: initialDate, finalDate: finalDate);
      _controller.points.add(_point);
    }

    return AppLayout(
        appBarTitle: 'Novo registro de ponto',
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(29.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Data',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                AppDatePicker(date: _date),
                const SizedBox(height: 15),
                const Text('Fatores de validação',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text('Reconhecimento Facial',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    Switch(
                        value: faceRecognitionFactor,
                        onChanged: (value) {
                          setState(() {
                            faceRecognitionFactor = value;
                          });
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text('Localização Indoor',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    Switch(
                        value: indoorLocationFactor,
                        onChanged: (value) {
                          setState(() {
                            indoorLocationFactor = value;
                          });
                        }),
                  ],
                ),
                const SizedBox(height: 15),
                indoorLocationFactor
                    ? Column(
                        children: [
                          const Text('Raio permitido em metros (m)',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                          Slider(
                            value: _allowableRadiusInMeters,
                            min: 0.0,
                            max: 10.0,
                            divisions: 5,
                            label: _allowableRadiusInMeters.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _allowableRadiusInMeters = value;
                              });
                            },
                          )
                        ],
                      )
                    : const SizedBox(),
                const Text('Pontos',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                      () {
                        return Column(
                          children: [
                            ListView.separated(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 15);
                              },
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _controller.points.length,
                              itemBuilder: (context, index) {
                                PointModel point = _controller.points[index];
                                return PointTimePicker(point: point);
                              },
                            ),
                            SizedBox(
                                height: _controller.points.isNotEmpty ? 15 : 0),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: newPoint,
                      child: const AppButton(
                        text: 'Ponto',
                        width: 100,
                        height: 40,
                        icon: Icon(Icons.add),
                        backgroundColor: Colors.green,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                AppButton(text: 'Cadastrar', onPressed: _create),
              ],
            ),
          ),
        ));
  }
}

class TimePickerCard extends StatefulWidget {
  const TimePickerCard(
      {super.key, required this.dateTime, required this.borderPosition});

  final DateTime dateTime;
  final AxisDirection borderPosition;

  @override
  State<TimePickerCard> createState() => _TimePickerCardState();
}

class _TimePickerCardState extends State<TimePickerCard> {
  TimeOfDay? selectedTime;

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
          setState(() {
            selectedTime = time;
          });
        },
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                width: 110,
                height: 35,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: const Offset(0, 1.5),
                  ),
                ], color: Colors.white),
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
