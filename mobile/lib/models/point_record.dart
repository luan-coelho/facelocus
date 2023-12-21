import 'package:mobile/models/event.dart';
import 'package:mobile/models/factor.dart';
import 'package:mobile/models/point.dart';

class PointRecord {
  late int id;
  late DateTime date;
  late Event event;
  late List<Point> points;
  late List<Factor> factors;
  late bool inProgress;

  PointRecord({
    required this.id,
    required this.date,
    required this.event,
    required this.points,
    required this.factors,
    required this.inProgress,
  });

  factory PointRecord.fromJson(Map<String, dynamic> json) {
    return PointRecord(
      id: json['id'] as int,
      date: DateTime.parse(json['date']),
      event: Event.fromJson(json['event']),
      points: (json['points'] as List)
          .map((e) => Point.fromJson(e as Map<String, dynamic>))
          .toList(),
      factors: (json['factors'] as List)
          .map((e) => Factor.values
              .firstWhere((element) => element.toString().split('.').last == e))
          .toList(),
      inProgress: json['inProgress'] as bool,
    );
  }
}
