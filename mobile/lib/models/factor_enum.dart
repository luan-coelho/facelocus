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

  @override
  String toString() {
    if (this == facialRecognition) {
      return 'Reconhecimento Facial';
    }

    if (this == indoorLocation) {
      return 'Localização Indoor';
    }

    return 'Fator não reconhecido';
  }
}
