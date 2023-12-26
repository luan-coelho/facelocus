import 'package:facelocus/models/event.dart';
import 'package:facelocus/models/ticket_request_status.dart';
import 'package:facelocus/models/user.dart';

class TicketRequest {
  late int id;
  late String code;
  late DateTime finalDateTime;
  late Event event;
  late TicketRequestStatus requestStatus;
  late User requester;
  late User requested;

  TicketRequest({
    required this.id,
    required this.code,
    required this.finalDateTime,
    required this.event,
    required this.requestStatus,
    required this.requester,
    required this.requested,
  });

  factory TicketRequest.fromJson(Map<String, dynamic> json) {
    return TicketRequest(
      id: json['id'] as int,
      code: json['code'],
      finalDateTime: DateTime.parse(json['finalDateTime']),
      event: Event.fromJson(json['event']),
      requestStatus: TicketRequestStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['requestStatus']),
      requester: User.fromJson(json['requester']),
      requested: User.fromJson(json['requested']),
    );
  }
}
