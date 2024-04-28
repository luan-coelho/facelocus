import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/models/user_attendace_model.dart';
import 'package:facelocus/service_locator.dart';
import 'package:facelocus/services/user_attendance_repository.dart';
import 'package:facelocus/utils/response_api_message.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';

part 'location_factor_validate_event.dart';
part 'location_factor_validate_state.dart';

class LocationFactorValidateBloc
    extends Bloc<LocationFactorValidateEvent, LocationFactorValidateState> {
  final UserAttendanceRepository userAttendanceRepository;

  LocationFactorValidateBloc({
    required this.userAttendanceRepository,
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
        Position position = await determinePosition();
        LocationModel location = event.userAttendance.pointRecord!.location!;
        double allowableRadiusInMeters =
            event.userAttendance.pointRecord!.allowableRadiusInMeters;
        double distance = calculateDistance(
          location.latitude,
          location.longitude,
          position.latitude,
          position.longitude,
        );
        if (distance > allowableRadiusInMeters) {
          emit(WithinThePermittedRadius());
        } else {
          emit(OutsideThePermittedRadius(userAttendance: event.userAttendance));
        }
      } on DioException catch (e) {
        emit(LocationFactorValidateError(
          message: ResponseApiMessage.buildMessage(e),
        ));
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
      var error = 'Os serviços de localização estão desativados.';
      return Future.error(error);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        var error = 'As permissões de localização foram negadas';
        return Future.error(error);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      var error = 'As permissões de localização foram negadas permanentemente,'
          'não é possivel solicitar permissões.';
      return Future.error(error);
    }
    return await Geolocator.getCurrentPosition();
  }
}
