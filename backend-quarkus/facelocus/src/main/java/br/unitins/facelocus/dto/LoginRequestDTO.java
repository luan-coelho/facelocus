package br.unitins.facelocus.dto;

import jakarta.validation.constraints.NotBlank;

public record LoginRequestDTO(@NotBlank(message = "Informe o login") String login,
                              @NotBlank(message = "Informe a senha") String password) {
}
