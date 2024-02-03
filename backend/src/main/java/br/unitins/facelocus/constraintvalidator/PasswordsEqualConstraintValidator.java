package br.unitins.facelocus.constraintvalidator;

import br.unitins.facelocus.dto.ChangePasswordDTO;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

public class PasswordsEqualConstraintValidator implements ConstraintValidator<PasswordsEqualConstraint, ChangePasswordDTO> {

    @Override
    public boolean isValid(ChangePasswordDTO changePasswordDTO, ConstraintValidatorContext context) {
        if (changePasswordDTO == null) {
            return true;
        }
        return changePasswordDTO.newPassword().equals(changePasswordDTO.confirmPassword());
    }
}
