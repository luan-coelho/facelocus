package br.unitins.facelocus.handle;

import br.unitins.facelocus.exception.ErrorResponse;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.vertx.core.http.HttpServerRequest;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;
import lombok.SneakyThrows;

import java.net.URI;
import java.net.URISyntaxException;

@Provider
public abstract class GlobalHandleException<T extends Exception> implements ExceptionMapper<T>, HandleExceptionMapper {

    @Context
    HttpServerRequest request;

    @SneakyThrows
    @Override
    public Response toResponse(Exception exception) {
        ErrorResponse errorResponse = buildResponse(exception);
        return Response.status(errorResponse.getStatus()).entity(errorResponse).build();
    }

    protected ErrorResponse buildResponse(Exception exception) throws URISyntaxException {
        return new ErrorResponse(
                new URI(""),
                getTitle(),
                getStatus(),
                exception.getMessage(),
                new URI(request.absoluteURI())
        );
    }

    public String getTitle() {
        return "Erro Interno do Servidor";
    }

    public int getStatus() {
        return HttpResponseStatus.INTERNAL_SERVER_ERROR.code();
    }
}

