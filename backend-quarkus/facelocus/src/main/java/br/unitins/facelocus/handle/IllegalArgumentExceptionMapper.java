package br.unitins.facelocus.handle;

import br.unitins.facelocus.exception.ErrorResponse;
import br.unitins.facelocus.mapper.ErrorResponseMapper;
import io.netty.handler.codec.http.HttpResponseStatus;
import jakarta.inject.Inject;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.Provider;
import lombok.SneakyThrows;

@SuppressWarnings("unused")
@Provider
public class IllegalArgumentExceptionMapper extends GlobalHandleException<IllegalArgumentException> {

    @Inject
    ErrorResponseMapper mapper;

    @SneakyThrows
    @Override
    public Response toResponse(IllegalArgumentException exception) {
        ErrorResponse errorResponse = buildResponse(exception);
        return Response.status(errorResponse.getStatus()).entity(errorResponse).build();
    }

    @Override
    public String getTitle() {
        return "Validação Falhou";
    }

    @Override
    public int getStatus() {
        return HttpResponseStatus.BAD_REQUEST.code();
    }
}

    