import 'dart:collection';

import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:facelocus/delegates/event_delegate.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_date_picker.dart';
import 'package:facelocus/shared/widgets/app_delete_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PointRecordCreateScreen extends StatefulWidget {
  const PointRecordCreateScreen({super.key});

  @override
  State<PointRecordCreateScreen> createState() =>
      _PointRecordCreateScreenState();
}

class _PointRecordCreateScreenState extends State<PointRecordCreateScreen> {
  late final PointRecordController _controller;
  bool faceRecognitionFactor = false;
  bool indoorLocationFactor = false;
  double _allowableRadiusInMeters = 5.0;
  late final RestorableDateTime _date;
  late PointModel _point;
  List<PointModel> points = [];
  HashSet<Factor> factors = HashSet();
  EventModel? _event;

  _create() {
    if (faceRecognitionFactor) {
      factors.add(Factor.facialRecognition);
    }
    if (indoorLocationFactor) {
      factors.add(Factor.indoorLocation);
      _controller.cleanPoint();
    }
    PointRecordModel pointRecord = PointRecordModel(
      event: _event,
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
    _date = RestorableDateTime(DateTime.now());
    super.initState();
  }

  @override
  void dispose() {
    _controller.cleanPointsList();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    newPoint() {
      DateTime initialDate = _controller.initialDate.value ?? DateTime.now();
      DateTime finalDate = _controller.finalDate.value ?? DateTime.now();
      PointModel pointSaved = PointModel(
          initialDate: initialDate.copyWith(), finalDate: finalDate.copyWith());
      _point = PointModel(initialDate: initialDate, finalDate: finalDate);
      _controller.points.add(pointSaved);
    }

    return AppLayout(
        appBarTitle: 'Novo registro de ponto',
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(29.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Evento',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Builder(builder: (context) {
                  if (_event != null) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_event!.description!),
                              const SizedBox(width: 5),
                              AppDeleteButton(onPressed: () {
                                setState(() {
                                  _event = null;
                                });
                              }),
                            ],
                          )
                        ]);
                  }
                  return AppButton(
                    text: 'Selecionar evento',
                    onPressed: () async {
                      var result = await showSearch(
                        context: context,
                        delegate: EventDelegate(),
                      );
                      setState(() {
                        _event = result;
                      });
                    },
                    textColor: AppColorsConst.black,
                    backgroundColor: Colors.black12.withOpacity(0.1),
                    height: 35,
                  );
                }),
                const SizedBox(height: 10),
                const Text('Data',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                AppDatePicker(date: _date),
                const SizedBox(height: 15),
                const Text('Fatores de validação',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text('Reconhecimento Facial',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(
                      width: 50,
                      height: 20,
                      child: Switch(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: faceRecognitionFactor,
                          onChanged: (value) {
                            setState(() {
                              faceRecognitionFactor = value;
                            });
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text('Localização Indoor',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(
                      width: 50,
                      height: 20,
                      child: Switch(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: indoorLocationFactor,
                          onChanged: (value) {
                            setState(() {
                              indoorLocationFactor = value;
                            });
                          }),
                    ),
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
                const MultiTimePicker(),
                const SizedBox(height: 15),
                AppButton(text: 'Cadastrar', onPressed: _create),
              ],
            ),
          ),
        ));
  }
}

class MultiTimePicker extends StatefulWidget {
  const MultiTimePicker({super.key});

  @override
  State<StatefulWidget> createState() => _MultiTimePickerState();
}

class _MultiTimePickerState extends State<MultiTimePicker> {
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

  void _addInterval() {
    setState(() {
      timeIntervals.add({'initialDate': _startTime, 'finalDate': _endTime});
    });
  }

  void _removeInterval(int index) {
    setState(() {
      timeIntervals.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _startTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    DateTime endTime = dateTime.add(const Duration(minutes: 15));
    _endTime = TimeOfDay(hour: endTime.hour, minute: endTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _selectTime(context, false),
          child: Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              width: MediaQuery.of(context).size.width,
              height: 35,
              decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hora inicial -',
                    style: TextStyle(
                        color: AppColorsConst.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _startTime.format(context),
                    style: const TextStyle(
                        color: AppColorsConst.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => _selectTime(context, false),
          child: Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              width: MediaQuery.of(context).size.width,
              height: 35,
              decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hora final -',
                    style: TextStyle(
                        color: AppColorsConst.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _endTime.format(context),
                    style: const TextStyle(
                        color: AppColorsConst.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: AppButton(
            onPressed: _addInterval,
            textColor: Colors.green,
            text: 'Adicionar intervalo',
            height: 35,
            textFontSize: 12,
            borderColor: Colors.green,
            backgroundColor: Colors.green.withOpacity(0.2),
          ),
        ),
        const SizedBox(height: 10),
        const Text('Intervalos', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        ListView.separated(
          shrinkWrap: true,
          itemCount: timeIntervals.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 5);
          },
          itemBuilder: (context, index) {
            final interval = timeIntervals[index];
            return Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                width: double.infinity,
                height: 45,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timelapse, color: Colors.black),
                        const SizedBox(width: 5),
                        Text(
                            '${interval['initialDate']!.format(context)} - ${interval['finalDate']!.format(context)}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w300)),
                      ],
                    ),
                    AppDeleteButton(onPressed: () => _removeInterval(index))
                  ],
                )));
          },
        ),
      ],
    );
  }
}
