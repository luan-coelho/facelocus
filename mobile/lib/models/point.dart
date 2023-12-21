import 'package:mobile/models/point_record.dart';

class Point {
  late int id;
  late DateTime initialDate;
  late int minutesToValidate;
  late bool validated;
  late PointRecord pointRecord;

  Point({
    required this.id,
    required this.initialDate,
    required this.minutesToValidate,
    required this.validated,
    required this.pointRecord,
  });

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      id: json['id'] as int,
      initialDate: DateTime.parse(json['initialDate']),
      minutesToValidate: json['minutesToValidate'] as int,
      validated: json['validated'] as bool,
      pointRecord: PointRecord.fromJson(json['pointRecord']),
    );
  }
}
