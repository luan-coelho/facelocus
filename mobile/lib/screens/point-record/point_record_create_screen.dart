import 'dart:collection';

import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:facelocus/delegates/event_delegate.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_date_picker.dart';
import 'package:facelocus/shared/widgets/app_delete_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  List<PointModel> points = [];
  HashSet<Factor> factors = HashSet();
  EventModel? _event;
  LocationModel? _location;

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
      location: _location,
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
    _controller.points.clear();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
        appBarTitle: 'Novo registro de ponto',
        showBottomNavigationBar: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(29.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Evento',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
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
                                  _location = null;
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
                    borderColor: Colors.transparent,
                    backgroundColor: Colors.black12.withOpacity(0.1),
                    height: 50,
                  );
                }),
                const SizedBox(height: 10),
                const Text('Localização',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                _event != null && _event?.locations != null
                    ? SizedBox(
                        height: 50,
                        child: DropdownButtonFormField<LocationModel>(
                          value: _location,
                          icon: const Icon(Icons.arrow_downward),
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusColor: AppColorsConst.white,
                              filled: true,
                              fillColor: Colors.black12.withOpacity(0.1)),
                          style: const TextStyle(color: Colors.black),
                          isExpanded: true,
                          hint: const Text('Selecione...',
                              style: TextStyle(fontFamily: 'Poppins')),
                          onChanged: (LocationModel? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              _location = value!;
                            });
                          },
                          items: _event?.locations!
                              .map<DropdownMenuItem<LocationModel>>(
                                  (LocationModel location) {
                            return DropdownMenuItem<LocationModel>(
                              value: location,
                              child: Text(location.description,
                                  style:
                                      const TextStyle(fontFamily: 'Poppins')),
                            );
                          }).toList(),
                        ),
                      )
                    : const Text('Informe o evento'),
                const SizedBox(height: 10),
                const Text('Data',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
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
                const SizedBox(height: 5),
                const MultiTimePicker(),
                const SizedBox(height: 10),
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
  late final PointRecordController _controller;
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
    _controller = Get.find<PointRecordController>();
    _startTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    DateTime endTime = dateTime.add(const Duration(minutes: 15));
    _endTime = TimeOfDay(hour: endTime.hour, minute: endTime.minute);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _selectTime(context, true),
          child: Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              width: MediaQuery.of(context).size.width,
              height: 50,
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
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _startTime.format(context),
                    style: const TextStyle(
                        color: AppColorsConst.black,
                        fontSize: 20,
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
              height: 50,
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
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _endTime.format(context),
                    style: const TextStyle(
                        color: AppColorsConst.black,
                        fontSize: 20,
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
            height: 50,
            textFontSize: 14,
            borderColor: Colors.green,
            backgroundColor: Colors.green.withOpacity(0.2),
          ),
        ),
        const SizedBox(height: 10),
        _controller.points.isNotEmpty
            ? const Column(
                children: [
                  Text('Intervalos',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                ],
              )
            : const SizedBox(),
        Obx(() {
          return ListView.separated(
            shrinkWrap: true,
            itemCount: _controller.points.length,
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
                      color: Colors.white),
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
                            final String finalDate =
                                formatter.format(point.finalDate);
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
