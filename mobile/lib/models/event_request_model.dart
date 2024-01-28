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
  UserModel requestOwner;

  EventRequestModel({
    this.id,
    this.code,
    required this.event,
    this.requestStatus,
    this.requestType,
    required this.requestOwner,
  });

  factory EventRequestModel.fromJson(Map<String, dynamic> json) {
    return EventRequestModel(
      id: json['id'] as int,
      code: json['code'],
      event: EventModel.fromJson(json['event']),
      requestStatus: EventRequestStatus.values
          .byName((json['requestStatus'] as String).toLowerCase()),
      requestType: EventRequestType.values
          .byName((json['requestType'] as String).toLowerCase()),
      requestOwner: UserModel.fromJson(json['requestOwner']),
    );
  }
}
