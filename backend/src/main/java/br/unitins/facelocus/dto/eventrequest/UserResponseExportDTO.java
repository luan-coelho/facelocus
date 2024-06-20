package br.unitins.facelocus.dto.eventrequest;

import java.time.LocalDateTime;

public record UserResponseExportDTO(
        Long id,
        String name,
        String surname,
        String email,
        String cpf,
        LocalDateTime createdAt,
        LocalDateTime updatedAt) {
}
