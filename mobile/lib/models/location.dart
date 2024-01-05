class Location {
  int? id;
  String? description;
  double? latitude;
  double? longitude;

  Location({
    required this.id,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  Location.empty();

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as int,
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
      };
}
