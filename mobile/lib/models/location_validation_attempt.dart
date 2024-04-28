class LocationValidationAttempt {
  final double latitude;
  final double longitude;
  final double distanceInMeters;
  final double allowedDistanceInMeters;
  final DateTime dateTime;
  final bool validated;

  LocationValidationAttempt({
    required this.latitude,
    required this.longitude,
    required this.distanceInMeters,
    required this.allowedDistanceInMeters,
    required this.dateTime,
    required this.validated,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'distanceInMeters': distanceInMeters,
      'allowedDistanceInMeters': allowedDistanceInMeters,
      'dateTime': dateTime.toIso8601String(),
      'validated': validated,
    };
  }
}
