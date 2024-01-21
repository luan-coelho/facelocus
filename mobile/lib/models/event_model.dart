import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/models/user_model.dart';

class EventModel {
  int? id;
  String? description;
  List<PointRecordModel>? pointRecords;
  List<LocationModel>? locations;
  UserModel? administrator;
  List<UserModel>? users;
  String? code;
  bool? allowTicketRequests = false;

  EventModel.empty();

  EventModel({
    this.id,
    required this.description,
    this.pointRecords,
    this.locations,
    required this.administrator,
    this.users,
    this.code,
    this.allowTicketRequests,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json['id'],
        description: json['description'],
        pointRecords: json['pointRecords'] == null
            ? null
            : (json['pointRecords'] as List)
                .map(
                    (e) => PointRecordModel.fromJson(e as Map<String, dynamic>))
                .toList(),
        locations: json['locations'] == null
            ? null
            : (json['locations'] as List)
                .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
                .toList(),
        administrator: /*UserModel.fromJson(json['administrator'])*/ null,
        users: json['users'] == null
            ? null
            : (json['users'] as List)
                .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
                .toList(),
        code: json['code'],
        allowTicketRequests: json['allowTicketRequests'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'locations': locations?.map((loc) => loc.toJson()).toList(),
        'administrator': administrator?.toJson(),
        'code': code,
        'allowTicketRequests': allowTicketRequests,
      };
}
