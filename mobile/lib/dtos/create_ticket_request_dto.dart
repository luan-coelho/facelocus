import 'package:facelocus/dtos/user_with_id_only_dto.dart';

import 'event_request_create_dto.dart';

class CreateInvitationDTO {
  EventWithCodeDTO event;
  UserWithIdOnly initiatorUser;
  UserWithIdOnly? targetUser;

  CreateInvitationDTO({
    required this.event,
    required this.initiatorUser,
    this.targetUser,
  });

  Map<String, dynamic> toJson() => {
        'event': event.toJson(),
        'initiatorUser': initiatorUser.toJson(),
        'targetUser': targetUser?.toJson()
      };
}
