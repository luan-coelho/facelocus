import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/models/user_attendace_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/point_record_repository.dart';
import 'package:facelocus/services/user_attendance_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'point_record_show_event.dart';
part 'point_record_show_state.dart';

class PointRecordShowBloc
    extends Bloc<PointRecordShowEvent, PointRecordShowState> {
  final PointRecordRepository pointRecordRepository;
  final UserAttendanceRepository userAttendanceRepository;
  final SessionRepository sessionRepository;

  PointRecordShowBloc({
    required this.pointRecordRepository,
    required this.userAttendanceRepository,
    required this.sessionRepository,
  }) : super(PointRecordShowInitial()) {
    on<LoadPointRecord>((event, emit) async {
      try {
        emit(PointRecordShowLoading());
        PointRecordModel pointRecord = await pointRecordRepository.getById(
          event.pointRecordId,
        );
        UserModel? user = await sessionRepository.getUser();
        var ua = await userAttendanceRepository.getByPointRecordAndUser(
          event.pointRecordId,
          user!.id!,
        );
        emit(PointRecordShowLoaded(
          pointRecord: pointRecord,
          userAttendance: ua,
        ));
      } on DioException catch (e) {
        emit(PointRecordShowError(message: ResponseApiMessage.buildMessage(e)));
      }
    });
  }
}
