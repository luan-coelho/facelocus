part of 'point_record_create_bloc.dart';

@immutable
abstract class PointRecordCreateEvent {}

class CreatePointRecord extends PointRecordCreateEvent {
  final EventModel event;
  final LocationModel? location;
  final DateTime date;
  final List<PointModel> points;
  final HashSet<Factor> factors;
  final double allowableRadiusInMeters;
  final bool faceRecognitionFactor;
  final bool locationFactor;

  CreatePointRecord({
    required this.event,
    this.location,
    required this.date,
    required this.points,
    required this.factors,
    required this.allowableRadiusInMeters,
    required this.faceRecognitionFactor,
    required this.locationFactor,
  });

  PointRecordModel createPointRecord() {
    List<Factor> factors = <Factor>[];
    if (faceRecognitionFactor) {
      factors.add(Factor.facialRecognition);
    }

    if (locationFactor) {
      factors.add(Factor.location);
    }
    return PointRecordModel(
      event: event,
      location: location,
      date: date,
      points: points,
      factors: factors,
      allowableRadiusInMeters: allowableRadiusInMeters,
    );
  }
}
