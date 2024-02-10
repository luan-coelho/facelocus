import 'dart:collection';

import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:facelocus/delegates/event_delegate.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/screens/point-record/widgets/point_time_picker.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_date_picker.dart';
import 'package:facelocus/shared/widgets/app_delete_button.dart';
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
      DateTime initialDate = DateTime.now();
      DateTime finalDate = DateTime.now();
      PointModel pointSaved = PointModel(
          initialDate: _controller.initialDate.value.copyWith(),
          finalDate: _controller.finalDate.value.copyWith());
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
                                return const SizedBox(height: 10);
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppButton(
                    onPressed: newPoint,
                    textColor: Colors.green,
                    text: 'Adicionar ponto',
                    height: 35,
                    textFontSize: 12,
                    borderColor: Colors.green,
                    backgroundColor: Colors.green.withOpacity(0.2),
                  ),
                ),
                const SizedBox(height: 15),
                AppButton(text: 'Cadastrar', onPressed: _create),
              ],
            ),
          ),
        ));
  }
}
