import 'package:facelocus/models/user_model.dart';

import 'event_request_create_dto.dart';

class CreateInvitationDTO {
  EventWithCodeDTO event;
  UserModel requestOwner;

  CreateInvitationDTO({
    required this.event,
    required this.requestOwner,
  });

  Map<String, dynamic> toJson() =>
      {'event': event.toJson(), 'requestOwner': requestOwner.toJson()};
}
