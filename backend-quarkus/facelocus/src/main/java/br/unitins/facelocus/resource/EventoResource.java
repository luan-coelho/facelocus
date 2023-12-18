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

@Path("/evento")
public class EventoResource {

    @Inject
    EventoService eventoService;

    @Inject
    EventoMapper eventoMapper;

    @GET
    public Response buscarTodos(Paginavel paginavel) {
        return Response.ok(eventoService.buscarTodosPaginados(paginavel).getDados()
                .stream()
                .map(p -> eventoMapper.toResource(p))
                .toList()).build();
    }

    @POST
    public Response criar(EventoDTO eventoDTO) {
        Evento evento = eventoMapper.toEntity(eventoDTO);
        evento = eventoService.criar(evento);
        EventoDTO dto = eventoMapper.toResource(evento);
        return Response.status(Response.Status.CREATED).entity(dto).build();
    }
}
