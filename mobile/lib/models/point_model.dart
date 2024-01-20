class PointModel {
  late int? id;
  late DateTime initialDate;
  late DateTime finalDate;
  late bool? validated;

  PointModel({
    this.id,
    required this.initialDate,
    required this.finalDate,
    this.validated,
  });

  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      id: json['id'] as int,
      initialDate: DateTime.parse(json['initialDate']),
      finalDate: DateTime.parse(json['finalDate']),
      validated: json['validated'] as bool,
    );
  }
}
