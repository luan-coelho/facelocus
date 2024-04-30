package br.unitins.facelocus.resource;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.eventrequest.EventRequestCreateDTO;
import br.unitins.facelocus.dto.eventrequest.EventRequestResponseDTO;
import br.unitins.facelocus.mapper.EventRequestMapper;
import br.unitins.facelocus.model.EventRequest;
import br.unitins.facelocus.model.EventRequestType;
import br.unitins.facelocus.service.EventRequestService;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Response;
import org.jboss.resteasy.reactive.RestQuery;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
@Authenticated
@Path("/event-request")
public class EventRequestResource {

    @Inject
    EventRequestService eventRequestService;

    @Inject
    EventRequestMapper eventRequestMapper;

    @GET
    public Response findAll(Pageable pageable,
                            @RestQuery("event") Long eventId,
                            @RestQuery("user") Long userId) {
        DataPagination<EventRequestResponseDTO> dataPagination;
        if (eventId != null && userId != null) {
            dataPagination = eventRequestService.findAllByEventAndUser(pageable, eventId, userId);
            return Response.ok(dataPagination).build();
        }

        if (userId != null) {
            dataPagination = eventRequestService.findAllByUser(pageable, userId);
            return Response.ok(dataPagination).build();
        }
        dataPagination = eventRequestService.findAllByEvent(pageable, eventId);
        return Response.ok(dataPagination).build();
    }

    @Path("/{id}")
    @GET
    public Response findById(@PathParam("id") Long eventRequestId) {
        EventRequest eventRequest = eventRequestService.findById(eventRequestId);
        EventRequestResponseDTO dto = eventRequestMapper.toResource(eventRequest);
        return Response.ok(dto).build();
    }

    @Path("/sent")
    @GET
    public Response findAllSent(Pageable pageable, @RestQuery("user") @Valid Long userId) {
        DataPagination<EventRequestResponseDTO> dataPagination = eventRequestService.findAllSentByUser(pageable, userId);
        return Response.ok(dataPagination).build();
    }

    @Path("/received")
    @GET
    public Response findAllReceived(Pageable pageable, @RestQuery("user") Long userId) {
        DataPagination<EventRequestResponseDTO> dataPagination = eventRequestService.findAllReceivedByUser(pageable, userId);
        return Response.ok(dataPagination).build();
    }

    @Path("/invitation")
    @POST
    public Response createInvitation(@Valid EventRequestCreateDTO requestCreateDTO) {
        eventRequestService.createInvitation(requestCreateDTO);
        return Response.status(Response.Status.CREATED).build();
    }

    @Path("/ticket-request")
    @POST
    public Response createTicketRequest(@Valid EventRequestCreateDTO requestRequestDTO) {
        eventRequestService.createTicketRequest(requestRequestDTO);
        return Response.status(Response.Status.CREATED).build();
    }

    @Path("/{id}")
    @DELETE
    public Response deleteById(@PathParam("id") Long eventRequestId) {
        eventRequestService.deleteById(eventRequestId);
        return Response.noContent().build();
    }

    @Path("/approve")
    @PATCH
    public Response approve(@RestQuery("user") Long userId,
                            @RestQuery("eventrequest") Long eventRequestId,
                            @RestQuery("requesttype") EventRequestType requestType) {
        eventRequestService.approve(userId, eventRequestId, requestType);
        return Response.ok().build();
    }

    @Path("/reject")
    @PATCH
    public Response reject(@RestQuery("eventRequest") Long eventRequestId) {
        eventRequestService.reject(eventRequestId);
        return Response.ok().build();
    }

}
