import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/models/event_request_status_enum.dart';
import 'package:facelocus/models/event_request_type_enum.dart';
import 'package:facelocus/models/user_model.dart';

class EventRequestModel {
  int? id;
  String? code;
  EventModel event;
  EventRequestStatus? requestStatus;
  EventRequestType? requestType;
  UserModel initiatorUser;
  UserModel targetUser;

  EventRequestModel({
    this.id,
    this.code,
    required this.event,
    this.requestStatus,
    this.requestType,
    required this.initiatorUser,
    required this.targetUser,
  });

  factory EventRequestModel.fromJson(Map<String, dynamic> json) {
    return EventRequestModel(
      id: json['id'] as int,
      code: json['code'],
      event: EventModel.fromJson(json['event']),
      requestStatus: json['requestStatus'] != null
          ? EventRequestStatus.parse(json['requestStatus'])
          : null,
      requestType: json['requestType'] != null
          ? EventRequestType.parse(json['requestType'])
          : null,
      initiatorUser: UserModel.fromJson(json['initiatorUser']),
      targetUser: UserModel.fromJson(json['targetUser']),
    );
  }
}
