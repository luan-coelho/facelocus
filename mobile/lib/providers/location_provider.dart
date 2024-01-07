import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/services/location_service.dart';
import 'package:flutter/foundation.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();

  Future<LocationModel>? _futureLocation;
  Future<List<LocationModel>>? _futureLocationsList;

  Future<LocationModel>? get futureEvent => _futureLocation;

  void refleshFutureById(int locationId) {
    _futureLocation = _locationService.getById(locationId);
    notifyListeners();
  }

  void refleshFutureListByEventId(int eventId) {
    _futureLocationsList = _locationService.getAllByEventId(eventId);
    notifyListeners();
  }
}
