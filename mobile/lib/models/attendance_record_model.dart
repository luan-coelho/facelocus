import 'package:facelocus/models/attendance_record_status_enum.dart';
import 'package:facelocus/models/point_model.dart';

class AttendanceRecordModel {
  int id;
  AttendanceRecordStatus? status;
  PointModel point;

  AttendanceRecordModel({
    required this.id,
    required this.status,
    required this.point,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id'] as int,
      status: json['status'] != null
          ? AttendanceRecordStatus.parse(json['status'])
          : null,
      point: PointModel.fromJson(json['point']),
    );
  }
}
