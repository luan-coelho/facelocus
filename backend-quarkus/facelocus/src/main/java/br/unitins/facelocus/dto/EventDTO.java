package br.unitins.facelocus.dto;

import jakarta.validation.constraints.NotBlank;

import java.util.List;

public record EventDTO(Long id,
                       @NotBlank(message = "Informe o campo descrição")
                       String description,
                       List<LocationDTO> locations,
                       String code,
                       boolean allowTicketRequests) {
}
