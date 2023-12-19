package br.unitins.facelocus.dto;

import br.unitins.facelocus.model.TicketRequestStatus;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;

public record TicketRequestDTO(
        Long id,
        @Size(min = 6, max = 6, message = "O código deve ter 6 dígitos")
        String code,
        LocalDateTime finalDateTime,
        EventDTO event,
        TicketRequestStatus requestStatus,
        UserResponseDTO requester,
        UserResponseDTO requested
) {
}