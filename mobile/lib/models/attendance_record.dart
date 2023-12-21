import 'package:mobile/models/point.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/models/user_face_photo.dart';

class AttendanceRecord {
  late int id;
  late DateTime dateTime;
  late User user;
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
      user: User.fromJson(json['user']),
      userFacePhoto: UserFacePhoto.fromJson(json['userFacePhoto']),
      point: Point.fromJson(json['point']),
    );
  }
}
