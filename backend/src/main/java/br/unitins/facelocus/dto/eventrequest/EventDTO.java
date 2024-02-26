package br.unitins.facelocus.dto.eventrequest;

import br.unitins.facelocus.dto.event.LocationDTO;
import br.unitins.facelocus.dto.user.UserResponseDTO;
import jakarta.validation.constraints.NotBlank;

import java.util.List;

public record EventDTO(Long id,
                       @NotBlank(message = "Informe o campo descrição")
                       String description,
                       List<LocationDTO> locations,
                       UserResponseDTO administrator,
                       List<UserResponseDTO> users,
                       String code,
                       boolean allowTicketRequests) {
}
