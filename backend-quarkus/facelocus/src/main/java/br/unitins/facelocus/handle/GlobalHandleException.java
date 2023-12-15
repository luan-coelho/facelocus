package br.unitins.facelocus.handle;

import br.unitins.facelocus.exception.ErrorResponse;
import io.vertx.core.http.HttpServerRequest;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;
import lombok.SneakyThrows;

import java.net.URI;
import java.net.URISyntaxException;

@Provider
public class GlobalHandleException implements ExceptionMapper<Exception> {

    @Context
    HttpServerRequest request;

    @SneakyThrows
    @Override
    public Response toResponse(Exception exception) {
        ErrorResponse errorResponse = buildResponse(exception);
        return Response.status(errorResponse.getStatus()).entity(errorResponse).build();
    }

    private ErrorResponse buildResponse(Exception exception) throws URISyntaxException {
        return ErrorResponse.builder()
                .type(new URI(""))
                .instance(new URI(request.absoluteURI()))
                .build();
    }
}

