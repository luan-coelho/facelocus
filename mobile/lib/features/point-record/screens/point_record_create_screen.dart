import 'dart:collection';

import 'package:facelocus/features/point-record/blocs/point-record-create/point_record_create_bloc.dart';
import 'package:facelocus/features/point-record/delegates/event_delegate.dart';
import 'package:facelocus/features/point-record/widgets/multi_time_picker.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_date_picker.dart';
import 'package:facelocus/shared/widgets/app_delete_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PointRecordCreateScreen extends StatefulWidget {
  const PointRecordCreateScreen({super.key});

  @override
  State<PointRecordCreateScreen> createState() =>
      _PointRecordCreateScreenState();
}

class _PointRecordCreateScreenState extends State<PointRecordCreateScreen> {
  EventModel? _event;
  LocationModel? _location;
  late DateTime _date;
  late bool _faceRecognitionFactor;
  late bool _indoorLocationFactor;
  late double _allowableRadiusInMeters;
  late List<PointModel> _points;
  late final HashSet<Factor> _factors;

  @override
  void initState() {
    _date = DateTime.now();
    _faceRecognitionFactor = false;
    _indoorLocationFactor = false;
    _allowableRadiusInMeters = 0.0;
    _points = <PointModel>[];
    _factors = HashSet<Factor>();
    super.initState();
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
              Builder(
                builder: (context) {
                  if (_event != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_event!.description!),
                            const SizedBox(width: 5),
                            AppDeleteButton(
                              onPressed: () {
                                setState(() {
                                  _event = null;
                                  _location = null;
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    );
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
                },
              ),
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
                      value: _faceRecognitionFactor,
                      onChanged: (value) {
                        setState(() {
                          _faceRecognitionFactor = value;
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
                      'Localização',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    height: 20,
                    child: Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: _indoorLocationFactor,
                      onChanged: (value) {
                        setState(() {
                          _indoorLocationFactor = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              if (_indoorLocationFactor) ...[
                const SizedBox(height: 5),
                if (_event != null && _event?.locations != null) ...[
                  const Text(
                    'Local de validação',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
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
                        fillColor: Colors.black12.withOpacity(0.1),
                      ),
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
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  )
                ],
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Raio permitido em metros (m)',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
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
                ),
                const SizedBox(),
              ],
              const Text(
                'Pontos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              PointsPicker(onPointListChanged: (points) {
                setState(() {
                  _points = points;
                });
              }),
              const SizedBox(height: 10),
              BlocConsumer<PointRecordCreateBloc, PointRecordCreateState>(
                listener: (context, state) {
                  if (state is PointRecordCreateSuccess) {
                    context.pushReplacement(
                      '/admin${AppRoutes.pointRecordEdit}/${state.pointRecord.id}',
                    );
                  }

                  if (state is PointRecordCreateError) {
                    return Toast.showError(state.message, context);
                  }
                },
                builder: (context, state) {
                  return AppButton(
                      isLoading: state is PointRecordCreateLoading,
                      text: 'Cadastrar',
                      onPressed: () => context
                          .read<PointRecordCreateBloc>()
                          .add(
                            CreatePointRecord(
                              event: _event!,
                              location: _location!,
                              date: _date,
                              points: _points,
                              factors: _factors,
                              allowableRadiusInMeters: _allowableRadiusInMeters,
                              faceRecognitionFactor: _faceRecognitionFactor,
                              locationFactor: _indoorLocationFactor,
                            ),
                          ),
                      disabled: _event == null ||
                          _location == null ||
                          _points.isEmpty);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
