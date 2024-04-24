import 'package:facelocus/models/device_model.dart';
import 'package:facelocus/models/user_face_photo_model.dart';

class UserModel {
  final int? id;
  final String name;
  final String surname;
  final String email;
  final String cpf;
  final String? password;
  final UserFacePhotoModel? facePhoto;
  final List<Device>? devices;

  UserModel({
    this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.cpf,
    this.password,
    this.facePhoto,
    this.devices,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      cpf: json['cpf'],
      password: json['password'],
      facePhoto: json['facePhoto'] != null
          ? UserFacePhotoModel.fromJson(json['facePhoto'])
          : null,
      /*devices: json['devices']
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

  Map<String, dynamic> toJsonWithFacePhoto() => {
        'id': id,
        'name': name,
        'surname': surname,
        'email': email,
        'cpf': cpf,
        'facePhoto': facePhoto?.toJson(),
        'password': password,
      };

  String getFullName() {
    return '$name $surname'.trim();
  }
}
