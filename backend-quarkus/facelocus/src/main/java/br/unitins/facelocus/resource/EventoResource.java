package br.unitins.facelocus.resource;

import br.unitins.facelocus.commons.pagination.Paginavel;
import br.unitins.facelocus.dto.EventoDTO;
import br.unitins.facelocus.mapper.EventoMapper;
import br.unitins.facelocus.model.Evento;
import br.unitins.facelocus.service.EventoService;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;

import java.net.URI;
import java.net.URISyntaxException;

@Path("/evento")
public class EventoResource {

    @Inject
    EventoService eventoService;

    @Inject
    EventoMapper eventoMapper;

    @GET
    public Response buscarTodos(Paginavel paginavel) {
        return Response.ok(eventoService.buscarTodos(paginavel)).build();
    }

    @POST
    public Response criar(EventoDTO eventoDTO) {
        Evento evento = eventoMapper.toEntity(eventoDTO);
        eventoService.criar(evento);
        return Response.status(Response.Status.CREATED).entity(evento).build();
    }
}
