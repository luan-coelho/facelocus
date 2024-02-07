package br.unitins.facelocus.dto.eventrequest;

import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.model.User;
import jakarta.validation.constraints.NotNull;

public record EventRequestCreateDTO(
        @NotNull(message = "Informe o evento")
        Event event,
        @NotNull(message = "Informe o usuário que está solicitando")
        User initiatorUser,
        User targetUser
) {
}