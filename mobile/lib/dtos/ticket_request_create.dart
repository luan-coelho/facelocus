import 'package:facelocus/dtos/event_ticket_request_create.dart';
import 'package:facelocus/models/user_model.dart';

class TicketRequestCreate {
  late EventTicketRequestCreate event;
  late UserModel user;

  TicketRequestCreate({
    required this.event,
    required this.user,
  });

  Map<String, dynamic> toJson() =>
      {'event': event.toJson(), 'user': user.toJson()};
}
