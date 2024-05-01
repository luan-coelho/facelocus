import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/models/user_attendace_model.dart';
import 'package:facelocus/services/point_record_repository.dart';
import 'package:facelocus/services/user_attendance_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:meta/meta.dart';

part 'point_record_admin_show_event.dart';
part 'point_record_admin_show_state.dart';

class PointRecordAdminShowBloc
    extends Bloc<PointRecordAdminShowEvent, PointRecordAdminShowState> {
  final UserAttendanceRepository userAttendanceRepository;
  final PointRecordRepository pointRecordRepository;

  PointRecordAdminShowBloc({
    required this.userAttendanceRepository,
    required this.pointRecordRepository,
  }) : super(PointRecordAdminShowInitial()) {
    on<LoadPointRecordAdminShow>((event, emit) async {
      try {
        emit(PointRecordAdminShowLoading());
        PointRecordModel pointRecord = await pointRecordRepository.getById(
          event.pointRecordId,
        );
        var uas = await userAttendanceRepository.getAllByPointRecord(
          event.pointRecordId,
        );

        if (uas.isEmpty) {
          emit(NoLinckedUsers(pointRecordId: event.pointRecordId));
          return;
        }

        emit(PointRecordAdminShowLoaded(
          pointRecord: pointRecord,
          userAttendances: uas,
        ));
      } on DioException catch (e) {
        emit(PointRecordAdminShowError(
          message: ResponseApiMessage.buildMessage(e),
        ));
      }
    });
  }
}
