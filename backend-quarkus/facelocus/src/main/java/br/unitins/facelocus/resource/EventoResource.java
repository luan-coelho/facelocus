package br.unitins.facelocus.resource;

import br.unitins.facelocus.commons.pagination.Paginavel;
import br.unitins.facelocus.model.Evento;
import br.unitins.facelocus.service.EventoService;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;

@Path("/evento")
public class EventoResource {

    @Inject
    EventoService eventoService;

    @GET
    public Response buscarTodos(Paginavel paginavel) {
        return Response.ok(eventoService.buscarTodos(paginavel)).build();
    }

    @POST
    public Response criar(Evento evento) {
        eventoService.criar(evento);
        return Response.status(Response.Status.CREATED).build();
    }
}
