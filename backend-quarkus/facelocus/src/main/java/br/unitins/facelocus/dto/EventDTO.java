package br.unitins.facelocus.dto;

import java.util.List;

public record EventDTO(Long id, String description, List<LocationDTO> locations, boolean allowTicketRequests) {
}
