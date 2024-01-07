import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/models/point_record.dart';
import 'package:facelocus/models/user.dart';

class Event {
  int? id;
  String? description;
  List<PointRecord>? pointRecords;
  List<LocationModel>? locations;
  User? administrator;
  List<User>? users;
  String? code;
  bool? allowTicketRequests = false;

  Event.empty();

  Event({
    this.id,
    required this.description,
    this.pointRecords,
    this.locations,
    required this.administrator,
    this.users,
    this.code,
    this.allowTicketRequests,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        description: json['description'],
        pointRecords: json['pointRecords'] == null
            ? null
            : (json['pointRecords'] as List)
                .map((e) => PointRecord.fromJson(e as Map<String, dynamic>))
                .toList(),
        locations: json['locations'] == null
            ? null
            : (json['locations'] as List)
                .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
                .toList(),
        administrator:
            User.fromJson(json['administrator'] as Map<String, dynamic>),
        users: json['users'] == null
            ? null
            : (json['users'] as List)
                .map((e) => User.fromJson(e as Map<String, dynamic>))
                .toList(),
        code: json['code'],
        allowTicketRequests: json['allowTicketRequests'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'locations': locations?.map((loc) => loc.toJson()).toList(),
        'administrator': /*administrator.toJson()*/ 1,
        'code': code,
        'allowTicketRequests': allowTicketRequests,
      };
}
