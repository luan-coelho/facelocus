import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/features/point-record/blocs/attendance-record/attendance_record_bloc.dart';
import 'package:facelocus/features/point-record/blocs/point-record-show/point_record_show_bloc.dart';
import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/models/location_validation_attempt.dart';
import 'package:facelocus/models/user_attendace_model.dart';
import 'package:facelocus/service_locator.dart';
import 'package:facelocus/services/point_record_repository.dart';
import 'package:facelocus/services/user_attendance_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

part 'location_factor_validate_event.dart';
part 'location_factor_validate_state.dart';

class LocationFactorValidateBloc
    extends Bloc<LocationFactorValidateEvent, LocationFactorValidateState> {
  final UserAttendanceRepository userAttendanceRepository;
  final PointRecordRepository pointRecordRepository;
  final AttendanceRecordBloc attendanceRecordBloc;
  final PointRecordShowBloc pointRecordShowBloc;

  LocationFactorValidateBloc({
    required this.userAttendanceRepository,
    required this.pointRecordRepository,
    required this.attendanceRecordBloc,
    required this.pointRecordShowBloc,
  }) : super(LocationFactorValidateInitial()) {
    on<LoadUserAttendace>((event, emit) async {
      try {
        emit(LocationFactorValidateLoading());
        var ua = await userAttendanceRepository.getById(event.userAttendanceId);
        emit(LocationFactorLoaded(userAttendance: ua));
      } on DioException catch (e) {
        emit(LocationFactorValidateError(
          message: ResponseApiMessage.buildMessage(e),
        ));
      }
    });

    on<ValidateLocation>((event, emit) async {
      try {
        emit(LocationFactorValidateLoading());
        var pointRecord = event.userAttendance.pointRecord;
        LocationModel location = pointRecord!.location!;
        double allowableRadiusInMeters = pointRecord.allowableRadiusInMeters;

        Position position = await determinePosition();
        double distance = calculateDistance(
          location.latitude,
          location.longitude,
          position.latitude,
          position.longitude,
        );
        if (distance < allowableRadiusInMeters) {
          await pointRecordRepository.validateLocationFactor(
            event.userAttendance.id!,
            LocationValidationAttempt(
              latitude: position.latitude,
              longitude: position.longitude,
              distanceInMeters: distance,
              allowedDistanceInMeters: allowableRadiusInMeters,
              dateTime: DateTime.now(),
              validated: true,
            ),
          );
          attendanceRecordBloc.add(LoadAttendanceRecord(
            attendanceRecordId: event.attendanceRecordId,
          ));
          pointRecordShowBloc.add(LoadPointRecord(
            pointRecordId: pointRecord.id,
          ));
          emit(WithinThePermittedRadius());
        } else {
          emit(OutsideThePermittedRadius(userAttendance: event.userAttendance));
        }
      } on DioException catch (e) {
        emit(LocationFactorValidateError(
          message: ResponseApiMessage.buildMessage(e),
        ));
      } catch (e) {
        emit(LocationFactorValidateError(
          message: e.toString(),
        ));
        emit(LocationFactorLoaded(userAttendance: event.userAttendance));
      }
    });
  }

  double calculateDistance(
    double latitude,
    double longitude,
    double curretLatitude,
    double currentLongitude,
  ) {
    if (curretLatitude == 0.0 && currentLongitude == 0.0) {
      return 0.0;
    }
    return Geolocator.distanceBetween(
      curretLatitude,
      currentLongitude,
      latitude,
      longitude,
    );
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;
    bool enabled = await Geolocator.isLocationServiceEnabled();

    if (enabled) {
      Location location = locator<Location>();
      enabled = await location.requestService();
    }

    if (!enabled) {
      throw 'Os serviços de localização estão desativados.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'As permissões de localização foram negadas';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'As permissões de localização foram negadas permanentemente,'
          'não é possivel solicitar permissões.';
    }
    return await Geolocator.getCurrentPosition();
  }
}
