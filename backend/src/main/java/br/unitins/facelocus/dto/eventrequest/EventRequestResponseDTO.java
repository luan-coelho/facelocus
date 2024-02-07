package br.unitins.facelocus.dto.eventrequest;

import br.unitins.facelocus.dto.EventDTO;
import br.unitins.facelocus.dto.UserResponseDTO;
import br.unitins.facelocus.model.EventRequestStatus;
import br.unitins.facelocus.model.EventRequestType;

public record EventRequestResponseDTO(
        Long id,
        String code,
        EventDTO event,
        EventRequestStatus requestStatus,
        EventRequestType requestType,
        UserResponseDTO initiatorUser,
        UserResponseDTO targetUser
) {
}