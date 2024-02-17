package br.unitins.facelocus.dto;

import java.time.LocalDateTime;

public record UserResponseDTO(
        Long id,
        String name,
        String surname,
        String email,
        String cpf,
        UserFacePhotoResponseDTO facePhoto,
        LocalDateTime createdAt,
        LocalDateTime updatedAt) {
}
