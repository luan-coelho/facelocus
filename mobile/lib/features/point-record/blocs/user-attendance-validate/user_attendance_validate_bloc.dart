import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/features/point-record/blocs/point-record-admin-show/point_record_admin_show_bloc.dart';
import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/services/point_record_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';

part 'user_attendance_validate_event.dart';
part 'user_attendance_validate_state.dart';

class UserAttendanceValidateBloc
    extends Bloc<UserAttendanceValidateEvent, UserAttendanceValidateState> {
  final PointRecordRepository pointRecordRepository;
  final PointRecordAdminShowBloc pointRecordAdminShowBloc;

  UserAttendanceValidateBloc({
    required this.pointRecordRepository,
    required this.pointRecordAdminShowBloc,
  }) : super(UserAttendanceValidateInitial()) {
    on<ValidatePoints>((event, emit) async {
      try {
        emit(ValidationLoading());
        await pointRecordRepository.validateUserPoints(event.attendanceRecords);
        pointRecordAdminShowBloc.add(LoadPointRecordAdminShow(
          pointRecordId: event.pointRecordId,
        ));
        emit(ValidationSucess());
      } on DioException catch (e) {
        emit(ValidationFailed(message: ResponseApiMessage.buildMessage(e)));
      }
    });
  }
}
