package br.unitins.facelocus.dto.ticketrequest;

import br.unitins.facelocus.dto.EventDTO;
import br.unitins.facelocus.dto.UserResponseDTO;
import br.unitins.facelocus.model.TicketRequestStatus;

public record TicketRequestResponseDTO(
        Long id,
        String code,
        EventDTO event,
        TicketRequestStatus requestStatus,
        UserResponseDTO user
) {
}