package br.unitins.facelocus.dto.eventrequest;

import br.unitins.facelocus.dto.EventDTO;
import br.unitins.facelocus.dto.UserResponseDTO;
import br.unitins.facelocus.model.EventRequestStatus;

public record EventRequestResponseDTO(
        Long id,
        String code,
        EventDTO event,
        EventRequestStatus requestStatus,
        UserResponseDTO requestOwner
) {
}