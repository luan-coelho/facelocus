class LocationModel {
  final int? id;
  String description;
  double latitude;
  double longitude;

  LocationModel({
    this.id,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      description: json['description'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
