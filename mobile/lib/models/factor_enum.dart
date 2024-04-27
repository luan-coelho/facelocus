enum Factor {
  facialRecognition,
  location;

  String toJson() {
    switch (this) {
      case Factor.facialRecognition:
        return 'FACIAL_RECOGNITION';
      case Factor.location:
        return 'INDOOR_LOCATION';
    }
  }

  static Factor? parse(String factor) {
    switch (factor) {
      case 'FACIAL_RECOGNITION':
        return Factor.facialRecognition;
      case 'INDOOR_LOCATION':
        return Factor.location;
    }
    return null;
  }

  @override
  String toString() {
    if (this == facialRecognition) {
      return 'Reconhecimento Facial';
    }

    if (this == location) {
      return 'Localização Indoor';
    }

    return 'Fator não reconhecido';
  }
}
