enum Factor {
  facialRecognition,
  indoorLocation;

  String toJson() {
    switch (this) {
      case Factor.facialRecognition:
        return 'FACIAL_RECOGNITION';
      case Factor.indoorLocation:
        return 'INDOOR_LOCATION';
    }
  }
}
