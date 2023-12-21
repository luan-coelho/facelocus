import 'package:mobile/models/location.dart';
import 'package:mobile/models/point_record.dart';
import 'package:mobile/models/user.dart';

class Event {
  late int id;
  late String description;
  late List<PointRecord>? pointRecords;
  late List<Location>? locations;
  late User administrator;
  late List<User>? users;
  late String code;
  late bool allowTicketRequests;

  Event({
    required this.id,
    required this.description,
    required this.pointRecords,
    required this.locations,
    required this.administrator,
    required this.users,
    required this.code,
    required this.allowTicketRequests,
  });

  Event.empty();

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
                .map((e) => Location.fromJson(e as Map<String, dynamic>))
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
}
