import 'package:facelocus/models/attendance_record_status_enum.dart';
import 'package:facelocus/models/point_model.dart';

class AttendanceRecordModel {
  int id;
  AttendanceRecordStatus status;
  PointModel point;
  bool frValidatedSuccessfully;
  bool locationValidatedSuccessfully;

  AttendanceRecordModel({
    required this.id,
    required this.status,
    required this.point,
    required this.frValidatedSuccessfully,
    required this.locationValidatedSuccessfully,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id'] as int,
      status: json['status'] != null
          ? AttendanceRecordStatus.parse(json['status']) ??
              AttendanceRecordStatus.pending
          : AttendanceRecordStatus.pending,
      point: PointModel.fromJson(json['point']),
      frValidatedSuccessfully: json['frValidatedSuccessfully'] as bool,
      locationValidatedSuccessfully:
          json['locationValidatedSuccessfully'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
      };
}
