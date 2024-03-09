import 'dart:collection';

import 'package:facelocus/controllers/point_record_edit_controller.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/screens/point-record/widgets/multi_time_picker.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_date_picker.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointRecordAdminEditScreen extends StatefulWidget {
  const PointRecordAdminEditScreen({super.key, required this.pointRecordId});

  final int pointRecordId;

  @override
  State<PointRecordAdminEditScreen> createState() =>
      _PointRecordAdminEditScreenState();
}

class _PointRecordAdminEditScreenState
    extends State<PointRecordAdminEditScreen> {
  late final PointRecordEditController _controller;
  bool faceRecognitionFactor = false;
  bool indoorLocationFactor = false;
  double _allowableRadiusInMeters = 5.0;
  late final RestorableDateTime _date;
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
      location: _controller.location.value,
      date: _controller.date.value ?? DateTime.now(),
      points: _controller.points,
      factors: factors.toList(),
      allowableRadiusInMeters: _allowableRadiusInMeters,
    );
    _controller.create(context, pointRecord);
  }

  @override
  void initState() {
    _controller = Get.find<PointRecordEditController>();
    _controller.fetchById(context, widget.pointRecordId);
    _date = RestorableDateTime(DateTime.now());
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
      appBarTitle: 'Editar registro de ponto',
      showBottomNavigationBar: false,
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(29.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Localização',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 50,
                child: DropdownButtonFormField<LocationModel>(
                  value: _controller.location.value,
                  icon: const Icon(Icons.arrow_downward),
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusColor: AppColorsConst.white,
                    filled: true,
                    fillColor: Colors.black12.withOpacity(0.1),
                  ),
                  style: const TextStyle(color: Colors.black),
                  isExpanded: true,
                  hint: const Text(
                    'Selecione...',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  onChanged: (LocationModel? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _controller.location.value = value!;
                    });
                  },
                  items: _controller.pointRecord.value!.event!.locations!
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
              ),
              const SizedBox(height: 10),
              const Text(
                'Data',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              AppDatePicker(date: _date),
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
                        }),
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
                        }),
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
                    _controller.location.value == null ||
                    _controller.points.isEmpty;
                return AppButton(
                    text: 'Atualizar', onPressed: _create, disabled: disable);
              }),
            ],
          ),
        ));
      }),
    );
  }
}
