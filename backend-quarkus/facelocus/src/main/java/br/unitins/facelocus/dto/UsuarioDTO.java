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
        @Email(message = "Informe o campo nome")
        String email,
        @CPF(message = "Informe o campo nome")
        String cpf,
        @NotBlank(message = "Informe o campo senha")
        String senha) {
}
