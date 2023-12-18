package br.unitins.facelocus.resource;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.EventDTO;
import br.unitins.facelocus.mapper.EventMapper;
import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.service.EventService;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Response;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
@Path("/event")
public class TicketRequestResource {

    @Inject
    EventService eventService;

    @Inject
    EventMapper eventMapper;

    @GET
    public Response findAll(Pageable pageable) {
        DataPagination<?> dataPagination = eventService.findAllPaginated(pageable);
        return Response.ok(dataPagination).build();
    }

    @POST
    public Response create(@Valid EventDTO eventDTO) {
        Event event = eventMapper.toCreateEntity(eventDTO);
        event = eventService.create(event);
        EventDTO dto = eventMapper.toResource(event);
        return Response.status(Response.Status.CREATED).entity(dto).build();
    }

    @Path("/{id}")
    @PUT
    public Response updateById(@PathParam("id") Long eventId, EventDTO eventDTO) {
        Event event = eventMapper.copyProperties(eventDTO);
        event = eventService.updateById(eventId, event);
        EventDTO dto = eventMapper.toResource(event);
        return Response.ok(dto).build();
    }

    @Path("/{id}")
    @DELETE
    public Response deleteById(@PathParam("id") Long eventId) {
        eventService.deleteById(eventId);
        return Response.noContent().build();
    }

    @Path("/change-ticket-request-permission/{id}")
    @PATCH
    public Response changeTicketRequestPermissionByEventId(@PathParam("id") Long eventId) {
        eventService.changeTicketRequestPermissionByEventId(eventId);
        return Response.noContent().build();
    }
}
