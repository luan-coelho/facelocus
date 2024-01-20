import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/models/point_model.dart';

class PointRecordModel {
  int? id;
  DateTime date;
  EventModel? event;
  List<PointModel> points;
  List<Factor> factors;
  double? allowableRadiusInMeters;
  bool? inProgress;

  PointRecordModel({
    this.id,
    required this.date,
    this.event,
    required this.points,
    required this.factors,
    this.allowableRadiusInMeters,
    this.inProgress,
  });

  factory PointRecordModel.fromJson(Map<String, dynamic> json) {
    return PointRecordModel(
      id: json['id'] as int,
      date: DateTime.parse(json['date']),
      event: EventModel.fromJson(json['event']),
      points: (json['points'] as List)
          .map((e) => PointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      factors: (json['factors'] as List)
          .map((e) => Factor.values
              .firstWhere((element) => element.toString().split('.').last == e))
          .toList(),
      inProgress: json['inProgress'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'event': event!.toJson(),
        'points': points.map((p) => p.toJson()).toList(),
        'allowableRadiusInMeters': allowableRadiusInMeters,
        'factors': factors.map((f) => f.toJson()).toList()
      };
}
