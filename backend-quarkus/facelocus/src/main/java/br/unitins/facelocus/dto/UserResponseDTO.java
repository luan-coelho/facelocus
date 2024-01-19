package br.unitins.facelocus.dto;

import br.unitins.facelocus.model.UserFacePhoto;

public record UserResponseDTO(
        Long id,
        String name,
        String surname,
        String email,
        String cpf,
        UserFacePhoto facePhoto) {
}
