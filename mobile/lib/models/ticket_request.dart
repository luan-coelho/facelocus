import 'package:facelocus/models/event.dart';
import 'package:facelocus/models/ticket_request_status.dart';
import 'package:facelocus/models/user_model.dart';

class TicketRequestModel {
  int? id;
  String? code;
  EventModel event;
  TicketRequestStatus? requestStatus;
  UserModel user;

  TicketRequestModel({
    this.id,
    this.code,
    required this.event,
    this.requestStatus,
    required this.user,
  });

  factory TicketRequestModel.fromJson(Map<String, dynamic> json) {
    return TicketRequestModel(
      id: json['id'] as int,
      code: json['code'],
      event: EventModel.fromJson(json['event']),
      requestStatus: TicketRequestStatus.values
          .byName((json['requestStatus'] as String).toLowerCase()),
      user: UserModel.fromJson(json['user']),
    );
  }
}
