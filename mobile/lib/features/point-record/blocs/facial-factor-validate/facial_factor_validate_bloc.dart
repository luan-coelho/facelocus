import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/features/point-record/blocs/point-record-show/point_record_show_bloc.dart';
import 'package:facelocus/services/point_record_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:meta/meta.dart';

part 'facial_factor_validate_event.dart';
part 'facial_factor_validate_state.dart';

class FacialFactorValidateBloc
    extends Bloc<FacialFactorValidateEvent, FacialFactorValidateState> {
  PointRecordRepository pointRecordRepository;
  PointRecordShowBloc pointRecordShowBloc;

  FacialFactorValidateBloc({
    required this.pointRecordRepository,
    required this.pointRecordShowBloc,
  }) : super(FacialFactorValidateInitial()) {
    on<ValidateFace>((event, emit) async {
      try {
        emit(ValidateFaceLoading());
        await pointRecordRepository.validateFacialRecognitionFactor(
          event.image,
          event.attendanceRecordId,
        );
        pointRecordShowBloc.add(
          LoadPointRecord(pointRecordId: event.pointRecordId),
        );
        emit(ValidateFaceSuccess());
      } on DioException catch (e) {
        emit(ValidateFaceError(message: ResponseApiMessage.buildMessage(e)));
      }
    });

    on<PhotoCaptured>((event, emit) async {
      emit(PhotoCapturedSuccess(image: event.image));
    });

    on<ResetCapture>((event, emit) async {
      emit(FacialFactorValidateInitial());
    });
  }
}
