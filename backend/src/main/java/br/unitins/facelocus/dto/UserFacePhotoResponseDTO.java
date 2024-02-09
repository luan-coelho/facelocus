package br.unitins.facelocus.dto;

import java.time.LocalDate;

public record UserFacePhotoResponseDTO(
        Long id,
        String fileName,
        LocalDate uploadDate,
        String filePath
) {
}