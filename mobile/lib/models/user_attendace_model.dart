import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/models/user_model.dart';

class UserAttendanceModel {
  int? id;
  UserModel? user;
  List<AttendanceRecordModel>? attendanceRecords;
  LocationModel location;

  UserAttendanceModel({
    required this.id,
    required this.user,
    required this.attendanceRecords,
    required this.location,
  });

  factory UserAttendanceModel.fromJson(Map<String, dynamic> json) {
    return UserAttendanceModel(
      id: json['id'] as int,
      user: UserModel.fromJson(json['user']),
      attendanceRecords: json['attendanceRecords'] == null
          ? null
          : (json['attendanceRecords'] as List)
              .map(
                (e) =>
                    AttendanceRecordModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      location: LocationModel.fromJson(json['pointRecord']['location']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}
