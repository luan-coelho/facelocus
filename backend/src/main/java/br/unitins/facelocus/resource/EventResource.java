package br.unitins.facelocus.resource;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.EventDTO;
import br.unitins.facelocus.mapper.EventMapper;
import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.service.EventService;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Response;
import org.jboss.resteasy.reactive.RestQuery;

import java.util.List;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
@Authenticated
@Path("/event")
public class EventResource {

    @Inject
    EventService eventService;

    @Inject
    EventMapper eventMapper;

    @GET
    public Response findAll(Pageable pageable, @RestQuery("user") Long userId) {
        DataPagination<?> dataPagination = eventService.findAllPaginatedByUser(pageable, userId);
        return Response.ok(dataPagination).build();
    }

    @Path("/search")
    @GET
    public Response findAllByDescription(@RestQuery("user") Long userId, @RestQuery("description") String description) {
        List<Event> events = eventService.findAllByDescription(userId, description);
        List<EventDTO> dtos = events.stream().map(e -> eventMapper.toResource(e)).toList();
        return Response.ok(dtos).build();
    }

    @Path("/{id}")
    @GET
    public Response findById(@PathParam("id") Long eventId) {
        Event event = eventService.findById(eventId);
        EventDTO dto = eventMapper.toResource(event);
        return Response.ok(dto).build();
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
        Event event = eventMapper.toUpdateEntity(eventDTO);
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

    @Path("/generate-new-code/{id}")
    @PATCH
    public Response generateNewCode(@PathParam("id") Long eventId) {
        eventService.generateNewCode(eventId);
        return Response.noContent().build();
    }

    @Path("/remove-user")
    @DELETE
    public Response removeUser(@RestQuery("event") Long eventId, @RestQuery("user") Long userId) {
        eventService.removeUser(eventId, userId);
        return Response.noContent().build();
    }
}