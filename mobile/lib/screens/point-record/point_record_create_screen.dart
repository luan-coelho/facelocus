import 'dart:collection';

import 'package:facelocus/controllers/point_record_create_controller.dart';
import 'package:facelocus/delegates/event_delegate.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/screens/point-record/widgets/multi_time_picker.dart';
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
  late final PointRecordCreateController _controller;
  bool faceRecognitionFactor = false;
  bool indoorLocationFactor = false;
  double _allowableRadiusInMeters = 5.0;
  DateTime? _date;
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
      date: _date ?? DateTime.now(),
      points: _controller.points,
      factors: factors.toList(),
      allowableRadiusInMeters: _allowableRadiusInMeters,
    );
    _controller.create(context, pointRecord);
  }

  @override
  void initState() {
    _controller = Get.find<PointRecordCreateController>();
    _date = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _controller.points.clear();
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
              const Text(
                'Evento',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
              const Text(
                'Localização',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              _event != null && _event?.locations != null
                  ? SizedBox(
                      height: 50,
                      child: DropdownButtonFormField<LocationModel>(
                        value: _location,
                        icon: const Icon(Icons.arrow_downward),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 0,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusColor: AppColorsConst.white,
                            filled: true,
                            fillColor: Colors.black12.withOpacity(0.1)),
                        style: const TextStyle(color: Colors.black),
                        isExpanded: true,
                        hint: const Text(
                          'Selecione...',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                        onChanged: (LocationModel? value) {
                          setState(() {
                            _location = value!;
                          });
                        },
                        items: _event?.locations!
                            .map<DropdownMenuItem<LocationModel>>(
                                (LocationModel location) {
                          return DropdownMenuItem<LocationModel>(
                            value: location,
                            child: Text(
                              location.description,
                              style: const TextStyle(fontFamily: 'Poppins'),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : const Text('Informe o evento'),
              const SizedBox(height: 10),
              const Text(
                'Data',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              AppDatePicker(
                onDateSelected: (date) => setState(() {
                  _date = date;
                }),
              ),
              const SizedBox(height: 15),
              const Text(
                'Fatores de validação',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text(
                      'Reconhecimento Facial',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    height: 20,
                    child: Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: faceRecognitionFactor,
                      onChanged: (value) {
                        setState(() {
                          faceRecognitionFactor = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text(
                      'Localização Indoor',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    height: 20,
                    child: Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: indoorLocationFactor,
                      onChanged: (value) {
                        setState(() {
                          indoorLocationFactor = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              indoorLocationFactor
                  ? Column(
                      children: [
                        const Text(
                          'Raio permitido em metros (m)',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
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
              const Text(
                'Pontos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const MultiTimePicker(),
              const SizedBox(height: 10),
              Builder(builder: (context) {
                bool disable = _event == null ||
                    _location == null ||
                    _controller.points.isEmpty;
                return AppButton(
                  text: 'Cadastrar',
                  onPressed: _create,
                  disabled: disable,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
