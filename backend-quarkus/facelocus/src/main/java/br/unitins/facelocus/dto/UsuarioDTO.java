package br.unitins.facelocus.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import org.hibernate.validator.constraints.br.CPF;

public record UsuarioDTO(
        Long id,
        @NotBlank(message = "Informe o campo nome")
        String nome,
        @NotBlank(message = "Informe o campo sobrenome")
        String sobreNome,
        @NotBlank(message = "Informe o campo email")
        @Email(message = "Informe um email valido")
        String email,
        @NotBlank(message = "Informe o campo cpf")
        @CPF(message = "Informe um cpf valido")
        String cpf,
        @NotBlank(message = "Informe o campo senha")
        String senha) {
}
