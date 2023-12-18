package br.unitins.facelocus.resource;

import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.EventDTO;
import br.unitins.facelocus.mapper.EventMapper;
import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.service.EventService;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;

@Path("/event")
public class EventResource {

    @Inject
    EventService eventService;

    @Inject
    EventMapper eventMapper;

    @GET
    public Response findAll(Pageable pageable) {
        return Response.ok(eventService.findAllPaginated(pageable).getData()
                .stream()
                .map(p -> eventMapper.toResource(p))
                .toList()).build();
    }

    @POST
    public Response create(EventDTO eventDTO) {
        Event event = eventMapper.toEntity(eventDTO);
        event = eventService.create(event);
        EventDTO dto = eventMapper.toResource(event);
        return Response.status(Response.Status.CREATED).entity(dto).build();
    }
}
