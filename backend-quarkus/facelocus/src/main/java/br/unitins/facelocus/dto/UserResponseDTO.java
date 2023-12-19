package br.unitins.facelocus.dto;

public record UserResponseDTO(
        Long id,
        String name,
        String surname,
        String email,
        String cpf) {
}
