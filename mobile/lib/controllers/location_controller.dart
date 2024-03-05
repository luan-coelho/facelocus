import 'package:dio/dio.dart';
import 'package:facelocus/services/location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import '../models/location_model.dart';
import '../shared/toast.dart';

class LocationController extends GetxController {
  final LocationService service;
  late int eventId;
  final Rxn<LocationModel> _location = Rxn<LocationModel>();
  final Rxn<LocationModel> _auxLocation = Rxn<LocationModel>();
  final List<LocationModel> _locations = <LocationModel>[].obs;
  final RxBool _showPosition = false.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _serviceEnabled = false.obs;
  final Location _locationLib = Location();

  LocationController({required this.service});

  Rxn<LocationModel> get location => _location;

  Rxn<LocationModel> get auxLocation => _location;

  List<LocationModel> get locations => _locations;

  RxBool get showPosition => _showPosition;

  RxBool get isLoading => _isLoading;

  Future<void> fetchAllByEventId(int eventId) async {
    _isLoading.value = true;
    var locations = await service.getAllByEventId(eventId);
    _locations.clear();
    _locations.addAll(locations);
    _isLoading.value = false;
  }

  Future<void> fetchById(int locationId) async {
    _isLoading.value = true;
    _location.value = await service.getById(locationId);
    _isLoading.value = false;
  }

  Future<void> create(LocationModel location, int eventId) async {
    _isLoading.value = true;
    await service.create(location, eventId);
    _showPosition.value = false;
    fetchAllByEventId(eventId);
  }

  deleteById(BuildContext context, int locationId, int eventId) async {
    _isLoading.value = true;
    try {
      await service.deleteById(locationId);
      Navigator.pop(context, "Ok");
    } on DioException catch (e) {
      Toast.showError(e.message!, context);
    }
    fetchAllByEventId(eventId);
  }

  void changeAuxiliaryLocation(LocationModel location) {
    _auxLocation.value = location;
  }

  void addLocation(BuildContext context, LocationModel location, int eventId) {
    _isLoading.value = true;
    if (_location.value?.latitude == 0.0 && _location.value?.longitude == 0.0) {
      Toast.showAlert('Sem localização definida', context);
      return;
    }
    service.create(location, eventId);
    newLocationInstace();
    fetchAllByEventId(eventId);
  }

  void removeUser(BuildContext context) {
    _isLoading.value = true;
    try {
      Navigator.pop(context, 'OK');
      Toast.showSuccess('Localização deletada com sucesso', context);
    } on DioException catch (e) {
      Toast.showError(e.message!, context);
    }
    _isLoading.value = true;
  }

  void savePosition(BuildContext context) async {
    _isLoading.value = true;
    try {
      Position position = await determinePosition(context);
      _location.value?.latitude = position.latitude;
      _location.value?.longitude = position.longitude;
      _showPosition.value = true;
    } on Exception catch (e) {
      if (context.mounted) {
        Toast.showError(e.toString(), context);
      }
    }
  }

  void newLocationInstace() {
    var location =
        LocationModel(description: '', latitude: 0.0, longitude: 0.0);
    _location.value = location;
  }

  Future<Position> determinePosition(BuildContext context) async {
    LocationPermission permission;

    _serviceEnabled.value = await Geolocator.isLocationServiceEnabled();

    if (!_serviceEnabled.value) {
      _serviceEnabled.value = await _locationLib.requestService();
    }

    if (!_serviceEnabled.value) {
      var error = 'Os serviços de localização estão desativados.';
      _isLoading.value = false;
      Toast.showAlert(error, context);
      return Future.error(error);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        var error = 'As permissões de localização foram negadas';
        _isLoading.value = false;
        Toast.showAlert(error, context);
        return Future.error(error);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      var error =
          'As permissões de localização foram negadas permanentemente, não é possivel solicitar permissões.';
      _isLoading.value = false;
      Toast.showAlert(error, context);
      return Future.error(error);
    }
    _isLoading.value = false;
    return await Geolocator.getCurrentPosition();
  }
}
