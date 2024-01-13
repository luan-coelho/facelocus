import 'package:facelocus/models/event.dart';
import 'package:facelocus/models/ticket_request_status.dart';
import 'package:facelocus/models/user_model.dart';

class TicketRequestModel {
  late int id;
  late String code;
  late DateTime finalDateTime;
  late EventModel event;
  late TicketRequestStatus requestStatus;
  late UserModel requester;
  late UserModel requested;

  TicketRequestModel({
    required this.id,
    required this.code,
    required this.finalDateTime,
    required this.event,
    required this.requestStatus,
    required this.requester,
    required this.requested,
  });

  factory TicketRequestModel.fromJson(Map<String, dynamic> json) {
    return TicketRequestModel(
      id: json['id'] as int,
      code: json['code'],
      finalDateTime: DateTime.parse(json['finalDateTime']),
      event: EventModel.fromJson(json['event']),
      requestStatus: TicketRequestStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['requestStatus']),
      requester: UserModel.fromJson(json['requester']),
      requested: UserModel.fromJson(json['requested']),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': event.code,
        'finalDateTime': finalDateTime,
        'request': requester.toJson(),
        'requested': requested.toJson()
      };
}
