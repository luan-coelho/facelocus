import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/models/user_model.dart';

class UserAttendanceModel {
  int? id;
  UserModel? user;
  List<AttendanceRecordModel>? attendanceRecords;
  bool validatedFaceRecognition;
  bool validatedLocation;
  UserAttendancePointRecord? pointRecord;

  UserAttendanceModel({
    required this.id,
    required this.user,
    required this.attendanceRecords,
    required this.validatedFaceRecognition,
    required this.validatedLocation,
    required this.pointRecord,
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
      validatedFaceRecognition: json['validatedFaceRecognition'] as bool,
      validatedLocation: json['validatedLocation'] as bool,
      pointRecord: json['pointRecord'] != null
          ? UserAttendancePointRecord.fromJson(json['pointRecord'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}

class UserAttendancePointRecord {
  int id;
  DateTime date;
  LocationModel? location;
  double allowableRadiusInMeters;
  bool inProgress;

  UserAttendancePointRecord({
    required this.id,
    required this.date,
    required this.location,
    required this.allowableRadiusInMeters,
    required this.inProgress,
  });

  factory UserAttendancePointRecord.fromJson(Map<String, dynamic> json) {
    return UserAttendancePointRecord(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      allowableRadiusInMeters: json['allowableRadiusInMeters'] as double,
      inProgress: json['inProgress'] as bool,
    );
  }
}
