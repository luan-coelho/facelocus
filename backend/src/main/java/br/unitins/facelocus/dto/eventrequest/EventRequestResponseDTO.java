package br.unitins.facelocus.dto.eventrequest;

import br.unitins.facelocus.dto.user.UserResponseDTO;
import br.unitins.facelocus.model.EventRequestStatus;
import br.unitins.facelocus.model.EventRequestType;

import java.time.LocalDateTime;

public record EventRequestResponseDTO(
        Long id,
        String code,
        EventDTO event,
        EventRequestStatus status,
        EventRequestType type,
        UserResponseDTO initiatorUser,
        UserResponseDTO targetUser,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {
}