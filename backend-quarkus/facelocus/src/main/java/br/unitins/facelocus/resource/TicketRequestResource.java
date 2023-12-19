package br.unitins.facelocus.resource;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.TicketRequestDTO;
import br.unitins.facelocus.mapper.TicketRequestMapper;
import br.unitins.facelocus.model.TicketRequest;
import br.unitins.facelocus.service.TicketRequestService;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Response;
import org.jboss.resteasy.reactive.RestQuery;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
@Path("/ticket-request")
public class TicketRequestResource {

    @Inject
    TicketRequestService ticketRequestService;

    @Inject
    TicketRequestMapper ticketRequestMapper;

    @GET
    public Response findAllByEvent(Pageable pageable, @RestQuery("event") Long eventId) {
        DataPagination<?> dataPagination = ticketRequestService.findAllPaginatedByEvent(pageable, eventId);
        return Response.ok(dataPagination).build();
    }

    @POST
    public Response create(@Valid TicketRequestDTO createTicketRequestDTO) {
        TicketRequest ticketRequest = ticketRequestMapper.toCreateEntity(createTicketRequestDTO);
        ticketRequestService.create(ticketRequest);
        return Response.status(Response.Status.CREATED).build();
    }

    @Path("/{id}")
    @DELETE
    public Response deleteById(@PathParam("id") Long ticketRequestId) {
        ticketRequestService.deleteById(ticketRequestId);
        return Response.noContent().build();
    }
}
