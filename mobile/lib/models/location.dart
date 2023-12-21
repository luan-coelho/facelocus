import 'package:mobile/models/event.dart';

class Location {
  late int id;
  late String description;
  late String latitude;
  late String longitude;

  Location({
    required this.id,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as int,
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
