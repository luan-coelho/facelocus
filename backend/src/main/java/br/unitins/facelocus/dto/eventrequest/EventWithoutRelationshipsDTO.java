package br.unitins.facelocus.dto.eventrequest;

import br.unitins.facelocus.dto.event.LocationDTO;
import br.unitins.facelocus.dto.user.UserResponseDTO;

import java.time.LocalDateTime;
import java.util.List;

public record EventWithoutRelationshipsDTO(Long id, String description, List<LocationDTO> locations,
                                           UserResponseDTO administrator,
                                           String code,
                                           List<UserResponseDTO> users,
                                           boolean allowTicketRequests,
                                           LocalDateTime createdAt,
                                           LocalDateTime updatedAt) {
}
