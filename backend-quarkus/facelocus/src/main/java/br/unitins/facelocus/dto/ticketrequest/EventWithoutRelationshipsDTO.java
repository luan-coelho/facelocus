package br.unitins.facelocus.dto.ticketrequest;

import br.unitins.facelocus.dto.LocationDTO;
import br.unitins.facelocus.dto.UserResponseDTO;

import java.util.List;

public record EventWithoutRelationshipsDTO(Long id, String description, List<LocationDTO> locations,
                                           UserResponseDTO administrator,
                                           String code,
                                           boolean allowTicketRequests) {
}
