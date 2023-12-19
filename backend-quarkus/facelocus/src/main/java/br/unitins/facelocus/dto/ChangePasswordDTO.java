package br.unitins.facelocus.dto;

import br.unitins.facelocus.constraintvalidator.PasswordsEqualConstraint;
import jakarta.validation.constraints.NotBlank;

@PasswordsEqualConstraint
public record ChangePasswordDTO(@NotBlank(message = "Informe a senha atual") String currentPassword,
                                @NotBlank(message = "Informe a nova senha") String newPassword,
                                @NotBlank(message = "Confirme a nova senha") String confirmPassword) {
}
