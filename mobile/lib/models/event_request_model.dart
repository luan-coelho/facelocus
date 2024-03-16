import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/models/event_request_status_enum.dart';
import 'package:facelocus/models/event_request_type_enum.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/models/user_model.dart';

class EventRequestModel {
  int? id;
  String? code;
  EventModel event;
  EventRequestStatus? status;
  EventRequestType? type;
  UserModel initiatorUser;
  UserModel targetUser;

  EventRequestModel({
    this.id,
    this.code,
    required this.event,
    this.status,
    this.type,
    required this.initiatorUser,
    required this.targetUser,
  });

  factory EventRequestModel.fromJson(Map<String, dynamic> json) {
    return EventRequestModel(
      id: json['id'] as int,
      code: json['code'],
      event: EventModel.fromJson(json['event']),
      status: json['status'] != null
          ? EventRequestStatus.parse(json['status'])
          : null,
      type: json['type'] != null ? EventRequestType.parse(json['type']) : null,
      initiatorUser: UserModel.fromJson(json['initiatorUser']),
      targetUser: UserModel.fromJson(json['targetUser']),
    );
  }
}
