import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/models/user_model.dart';

class UserAttendanceModel {
  int? id;
  UserModel? user;
  List<AttendanceRecordModel>? attendanceRecords;

  UserAttendanceModel({
    required this.id,
    required this.user,
    required this.attendanceRecords,
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
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}
