package br.unitins.facelocus.mapper;

import br.unitins.facelocus.exception.ErrorResponse;
import br.unitins.facelocus.exception.ValidationErrorResponse;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface ErrorResponseMapper {

    ValidationErrorResponse copyProperties(ErrorResponse errorResponse);

    ValidationErrorResponse copyProperties(ValidationErrorResponse errorResponse);
}
