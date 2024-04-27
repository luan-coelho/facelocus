import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/features/home/bloc/home/home_bloc.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/models/point_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/services/point_record_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'point_record_create_event.dart';
part 'point_record_create_state.dart';

class PointRecordCreateBloc
    extends Bloc<PointRecordCreateEvent, PointRecordCreateState> {
  final PointRecordRepository pointRecordRepository;
  final HomeBloc homeBloc;

  PointRecordCreateBloc({
    required this.pointRecordRepository,
    required this.homeBloc,
  }) : super(PointRecordCreateInitial()) {
    on<CreatePointRecord>((event, emit) async {
      try {
        emit(PointRecordCreateLoading());
        var pr = await pointRecordRepository.create(event.createPointRecord());
        homeBloc.add(LoadPointRecords());
        emit(PointRecordCreateSuccess(pointRecord: pr));
      } on DioException catch (e) {
        emit(PointRecordCreateError(
          message: ResponseApiMessage.buildMessage(e),
        ));
      }
    });
  }
}
