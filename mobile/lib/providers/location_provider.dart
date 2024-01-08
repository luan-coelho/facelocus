import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/services/location_service.dart';
import 'package:flutter/foundation.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();
  late int eventId;
  late LocationModel _location;
  List<LocationModel> _locations = [];
  bool isLoading = false;

  LocationModel get location => _location;

  List<LocationModel> get locations => _locations;

  Future<void> fetchAllByEventId(int eventId) async {
    isLoading = true;
    notifyListeners();

    _locations = await _locationService.getAllByEventId(eventId);

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchById(int locationId) async {
    isLoading = true;
    notifyListeners();

    _location = await _locationService.getById(locationId);

    isLoading = false;
    notifyListeners();
  }

  Future<void> create(LocationModel locationModel, int eventId) async {
    await _locationService.create(locationModel, eventId);
    fetchAllByEventId(eventId);
  }

  Future<void> deleteById(int locationId, int eventId) async {
    await _locationService.deleteById(locationId);
    fetchAllByEventId(eventId);
  }
}
