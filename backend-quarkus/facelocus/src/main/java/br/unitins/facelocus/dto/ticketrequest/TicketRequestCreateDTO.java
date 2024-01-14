package br.unitins.facelocus.dto.ticketrequest;

import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.model.User;
import jakarta.validation.constraints.NotNull;

public record TicketRequestCreateDTO(
        @NotNull(message = "Informe o evento")
        Event event,
        @NotNull(message = "Informe o usuário solicitado ou solicitante")
        User user
) {
}