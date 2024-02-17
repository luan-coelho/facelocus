package br.unitins.facelocus.dto;

import java.time.LocalDateTime;

public record UserFacePhotoResponseDTO(
        Long id,
        String fileName,
        String filePath,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {
}