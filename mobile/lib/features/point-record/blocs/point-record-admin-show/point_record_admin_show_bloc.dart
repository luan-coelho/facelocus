import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/features/home/bloc/home/home_bloc.dart';
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
  final PointRecordRepository pointRecordRepository;
  final UserAttendanceRepository userAttendanceRepository;
  final HomeBloc homeBloc;

  PointRecordAdminShowBloc({
    required this.pointRecordRepository,
    required this.userAttendanceRepository,
    required this.homeBloc,
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

    on<DeletePointRecordAdminShow>((event, emit) async {
      try {
        emit(PointRecordAdminShowLoading());
        await pointRecordRepository.deleteById(event.pointRecordId);
        homeBloc.add(LoadPointRecords());
        emit(SuccessfullDeletion());
      } on DioException catch (e) {
        emit(PointRecordAdminShowError(
          message: ResponseApiMessage.buildMessage(e),
        ));
      }
    });
  }
}
