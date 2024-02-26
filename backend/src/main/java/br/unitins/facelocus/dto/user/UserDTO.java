package br.unitins.facelocus.dto.user;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import org.hibernate.validator.constraints.br.CPF;

public record UserDTO(
        Long id,
        @NotBlank(message = "Informe o campo nome")
        String name,
        @NotBlank(message = "Informe o campo sobrenome")
        String surname,
        @NotBlank(message = "Informe o campo email")
        @Email(message = "Informe um email válido")
        String email,
        @NotBlank(message = "Informe o campo cpf")
        @CPF(message = "Informe um CPF válido")
        String cpf,
        @NotBlank(message = "Informe o campo senha")
        String password) {
}
