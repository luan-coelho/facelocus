import 'package:facelocus/models/point.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/models/user_face_photo.dart';

class AttendanceRecord {
  late int id;
  late DateTime dateTime;
  late UserModel user;
  late UserFacePhoto userFacePhoto;
  late Point point;

  AttendanceRecord({
    required this.id,
    required this.dateTime,
    required this.user,
    required this.userFacePhoto,
    required this.point,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as int,
      dateTime: DateTime.parse(json['dateTime']),
      user: UserModel.fromJson(json['user']),
      userFacePhoto: UserFacePhoto.fromJson(json['userFacePhoto']),
      point: Point.fromJson(json['point']),
    );
  }
}
