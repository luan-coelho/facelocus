package br.unitins.facelocus.handle;

import br.unitins.facelocus.exception.AuthenticationException;
import br.unitins.facelocus.exception.ErrorResponse;
import br.unitins.facelocus.mapper.ErrorResponseMapper;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.vertx.core.http.HttpServerRequest;
import jakarta.inject.Inject;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;
import lombok.SneakyThrows;

@SuppressWarnings("unused")
@Provider
public class AuthenticationExceptionMapper implements ExceptionMapper<AuthenticationException>, HandleExceptionMapper {

    @Context
    HttpServerRequest request;

    @Inject
    ErrorResponseMapper mapper;

    @SneakyThrows
    @Override
    public Response toResponse(AuthenticationException exception) {
        ErrorResponse errorResponse = buildResponse(exception, request);
        return Response.status(errorResponse.getStatus()).entity(errorResponse).build();
    }

    @Override
    public String getTitle() {
        return "Authentication failed";
    }

    @Override
    public int getStatus() {
        return HttpResponseStatus.BAD_REQUEST.code();
    }
}

    