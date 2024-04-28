import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/features/point-record/repositories/attendance_record_repository.dart';
import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'attendance_record_event.dart';
part 'attendance_record_state.dart';

class AttendanceRecordBloc
    extends Bloc<AttendanceRecordEvent, AttendanceRecordState> {
  final AttendanceRecordRepository attendanceRecordRepository;

  AttendanceRecordBloc({
    required this.attendanceRecordRepository,
  }) : super(AttendanceRecordInitial()) {
    on<LoadAttendanceRecord>((event, emit) async {
      try {
        emit(AttendanceRecordLoading());
        var attendanceRecord = await attendanceRecordRepository.getById(
          event.attendanceRecordId,
        );
        emit(AttendanceRecordLoaded(attendanceRecord: attendanceRecord));
      } on DioException catch (e) {
        emit(AttendanceRecordError(
          message: ResponseApiMessage.buildMessage(e),
        ));
      }
    });
  }
}
