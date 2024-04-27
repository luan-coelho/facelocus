import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/point_record_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<PointRecordEvent, HomeState> {
  final PointRecordRepository pointRecordRepository;
  final SessionRepository sessionRepository;

  HomeBloc({
    required this.pointRecordRepository,
    required this.sessionRepository,
  }) : super(PointRecordInitial()) {
    on<LoadPointRecords>((event, emit) async {
      try {
        emit(PointRecordLoading());
        UserModel? user = await sessionRepository.getUser();
        var pointRecords = await pointRecordRepository.getAllByUser(user!.id!);
        emit(PointRecordLoaded(
          loggedUser: user,
          pointRecordsEventsList: await buildPointsRecordEvents(pointRecords),
        ));
      } on DioException catch (e) {
        emit(PointRecordError(ResponseApiMessage.buildMessage(e)));
      }
    });
  }

  Future<List<NeatCleanCalendarEvent>> buildPointsRecordEvents(
    List<PointRecordModel> pointsRecord,
  ) async {
    List<NeatCleanCalendarEvent> eventList = [];
    for (var pr in pointsRecord) {
      DateTime startTime = pr.points.first.initialDate;
      DateTime finalTime = pr.points.last.finalDate;
      var prEvent = NeatCleanCalendarEvent(
        pr.event!.description!,
        description: pr.location!.description,
        startTime: startTime,
        endTime: finalTime,
        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        metadata: pr.toJson(),
      );
      eventList.add(prEvent);
    }
    return eventList;
  }
}
