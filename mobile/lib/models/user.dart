import 'package:facelocus/models/device.dart';
import 'package:facelocus/models/user_face_photo.dart';

class User {
  late int id;
  late String name;
  late String surname;
  late String email;
  late String cpf;
  late String? password;
  late UserFacePhoto? userFacePhoto;
  late List<Device>? devices;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.cpf,
    this.password,
    this.userFacePhoto,
    this.devices,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      cpf: json['cpf'],
      password: json['password'],
      /* userFacePhoto: json['userFacePhoto']
          ? null
          : UserFacePhoto.fromJson(json['userFacePhoto']),
      devices: json['devices']
          ? null
          : (json['devices'] as List)
              .map((e) => Device.fromJson(e as Map<String, dynamic>))
              .toList(),*/
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'surname': surname,
        'email': email,
        'cpf': cpf,
        'password': password,
      };

  String getFullName() {
    return '$name $surname'.trim();
  }
}
