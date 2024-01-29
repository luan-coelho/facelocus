import 'package:facelocus/dtos/user_with_id_only_dto.dart';

import 'event_request_create_dto.dart';

class CreateInvitationDTO {
  EventWithCodeDTO event;
  UserWithIdOnly requestOwner;

  CreateInvitationDTO({
    required this.event,
    required this.requestOwner,
  });

  Map<String, dynamic> toJson() =>
      {'event': event.toJson(), 'requestOwner': requestOwner.toJson()};
}
