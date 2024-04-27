import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'point_record_create_event.dart';
part 'point_record_create_state.dart';

class PointRecordCreateBloc
    extends Bloc<PointRecordCreateEvent, PointRecordCreateState> {
  final PointRecordRepository pointRecordRepository;

  PointRecordCreateBloc({
    required this.pointRecordRepository,
  }) : super(PointRecordCreateInitial()) {
    on<CreatePointRecord>((event, emit) async {
      try {
        emit(PointRecordCreateLoading());
        await pointRecordRepository.create(event.createPointRecord());
        emit(PointRecordCreateSuccess());
      } on DioException catch (e) {
        emit(PointRecordCreateError(
          message: ResponseApiMessage.buildMessage(e),
        ));
      }
    });
  }
}
