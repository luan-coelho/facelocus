class Location {
  int? id;
  String? description;
  late double latitude;
  late double longitude;

  Location({
    required this.id,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  Location.empty();

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      description: json['description'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
      };
}
