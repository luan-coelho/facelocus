class PointModel {
  late int? id;
  late DateTime initialDate;
  late DateTime finalDate;

  PointModel({
    this.id,
    required this.initialDate,
    required this.finalDate,
  });

  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      id: json['id'] != null ? json['id'] as int : null,
      initialDate: DateTime.parse(json['initialDate']),
      finalDate: DateTime.parse(json['finalDate']),
    );
  }

  Map<String, dynamic> toJson() => {
        'initialDate': initialDate.toIso8601String(),
        'finalDate': finalDate.toIso8601String(),
      };
}
