package br.unitins.facelocus.handle;

import br.unitins.facelocus.exception.ErrorResponse;
import io.vertx.core.http.HttpServerRequest;

import java.net.URI;
import java.net.URISyntaxException;

public interface HandleExceptionMapper {

    String getTitle();

    int getStatus();

    default ErrorResponse buildResponse(Throwable exception, HttpServerRequest request) throws URISyntaxException {
        return new ErrorResponse(
                new URI(""),
                getTitle(),
                getStatus(),
                exception.getCause() != null ? exception.getCause().getMessage() : exception.getMessage(),
                new URI(request.absoluteURI())
        );
    }
}
