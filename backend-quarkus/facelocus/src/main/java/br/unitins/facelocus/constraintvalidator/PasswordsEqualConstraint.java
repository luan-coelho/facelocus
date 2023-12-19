package br.unitins.facelocus.constraintvalidator;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.*;

@Target({ElementType.TYPE, ElementType.ANNOTATION_TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = PasswordsEqualConstraintValidator.class)
@Documented
public @interface PasswordsEqualConstraint {
    String message() default "As senhas não coincidem";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
