package br.unitins.facelocus.handle;

import br.unitins.facelocus.exception.ErrorResponse;
import br.unitins.facelocus.exception.ValidationErrorResponse;
import br.unitins.facelocus.mapper.ErrorResponseMapper;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.vertx.core.http.HttpServerRequest;
import jakarta.inject.Inject;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import jakarta.validation.ValidationException;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;
import lombok.SneakyThrows;

@SuppressWarnings("unused")
@Provider
public class ValidationExceptionMapper implements ExceptionMapper<ValidationException>, HandleExceptionMapper {

    @Context
    HttpServerRequest request;

    @Inject
    ErrorResponseMapper mapper;

    @SneakyThrows
    @Override
    public Response toResponse(ValidationException exception) {
        ErrorResponse errorResponse = buildResponse(exception, request);
        ConstraintViolationException constraintViolationException = (ConstraintViolationException) exception;
        ValidationErrorResponse validationErrorResponse = mapper.copyProperties(errorResponse);
        validationErrorResponse.setDetail("Erro de validação ocorrido");
        injectErrors(validationErrorResponse, constraintViolationException);
        return Response.status(errorResponse.getStatus()).entity(validationErrorResponse).build();
    }

    @Override
    public String getTitle() {
        return "Violação de Restrição";
    }

    @Override
    public int getStatus() {
        return HttpResponseStatus.BAD_REQUEST.code();
    }

    private void injectErrors(ValidationErrorResponse errorResponse, ConstraintViolationException exception) {
        for (ConstraintViolation<?> violation : exception.getConstraintViolations()) {
            String fieldName = extractFieldName(violation.getPropertyPath().toString());
            String errorMessage = violation.getMessage();
            errorResponse.addInvalidField(fieldName, errorMessage);
        }
    }

    private String extractFieldName(String fullFieldName) {
        int lastDotIndex = fullFieldName.lastIndexOf('.');
        return lastDotIndex != -1 ? fullFieldName.substring(lastDotIndex + 1) : fullFieldName;
    }
}

    