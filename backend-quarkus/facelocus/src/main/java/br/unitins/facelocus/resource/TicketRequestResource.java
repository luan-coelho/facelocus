package br.unitins.facelocus.resource;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.TicketRequestDTO;
import br.unitins.facelocus.mapper.TicketRequestMapper;
import br.unitins.facelocus.model.TicketRequest;
import br.unitins.facelocus.service.TicketRequestService;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Response;
import org.jboss.resteasy.reactive.RestQuery;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
@Path("/ticket-request")
@Authenticated
public class TicketRequestResource {

    @Inject
    TicketRequestService ticketRequestService;

    @Inject
    TicketRequestMapper ticketRequestMapper;

    @GET
    public Response findAllByEvent(Pageable pageable, @RestQuery("event") Long eventId) {
        DataPagination<?> dataPagination = ticketRequestService.findAllByEvent(pageable, eventId);
        return Response.ok(dataPagination).build();
    }

    @Path("/by-user")
    @GET
    public Response findAllByUser(Pageable pageable, @RestQuery("user") Long userId) {
        DataPagination<?> dataPagination = ticketRequestService.findAllByUser(pageable, userId);
        return Response.ok(dataPagination).build();
    }

    @Path("/sent")
    @GET
    public Response findAllSent(Pageable pageable, @RestQuery("user") @Valid Long userId) {
        DataPagination<?> dataPagination = ticketRequestService.findAllSentByUser(pageable, userId);
        return Response.ok(dataPagination).build();
    }

    @Path("/received")
    @GET
    public Response findAllReceived(Pageable pageable, @RestQuery("user") Long userId) {
        DataPagination<?> dataPagination = ticketRequestService.findAllReceivedByUser(pageable, userId);
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

    @Path("/approve")
    @PATCH
    public Response approve(@RestQuery("user") Long userId, @RestQuery("ticketrequest") Long ticketRequestId) {
        ticketRequestService.approve(userId, ticketRequestId);
        return Response.ok().build();
    }

    @Path("/reject")
    @PATCH
    public Response reject(@RestQuery("user") Long userId, @RestQuery("ticketrequest") Long ticketRequestId) {
        ticketRequestService.reject(userId, ticketRequestId);
        return Response.ok().build();
    }
}
