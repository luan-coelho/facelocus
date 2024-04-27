import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/models/point_model.dart';

class PointRecordModel {
  int? id;
  DateTime date;
  EventModel? event;
  LocationModel? location;
  List<PointModel> points;
  List<Factor>? factors;
  double? allowableRadiusInMeters;
  bool? inProgress;

  PointRecordModel({
    this.id,
    required this.date,
    this.event,
    this.location,
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
      location: LocationModel.fromJson(json['location']),
      points: (json['points'] as List)
          .map((e) => PointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      factors: json['factors'] != null && (json['factors'] as List).isNotEmpty
          ? (json['factors'] as List)
              .map((typeItem) => Factor.parse(typeItem)!)
              .toList()
          : null,
      inProgress: json['inProgress'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'event': event!.toJson(),
        'location': location!.toJson(),
        'points': points.map((p) => p.toJson()).toList(),
        'allowableRadiusInMeters': allowableRadiusInMeters,
        'factors': factors!.map((f) => f.toJson()).toList(),
      };
}
