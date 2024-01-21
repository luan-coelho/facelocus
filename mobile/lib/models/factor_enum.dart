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

  static Factor? parse(String factor) {
    switch (factor) {
      case 'FACIAL_RECOGNITION':
        return Factor.facialRecognition;
      case 'INDOOR_LOCATION':
        return Factor.indoorLocation;
    }
    return null;
  }
}
