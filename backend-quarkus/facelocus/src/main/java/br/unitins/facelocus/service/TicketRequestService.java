package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.TicketRequestDTO;
import br.unitins.facelocus.mapper.TicketRequestMapper;
import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.model.TicketRequest;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.repository.TicketRequestRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;

@ApplicationScoped
public class TicketRequestService extends BaseService<TicketRequest, TicketRequestRepository> {

    @Inject
    TicketRequestMapper ticketRequestMapper;

    @Inject
    UserService userService;

    @Inject
    EventService eventService;

    public DataPagination<?> findAllPaginatedByEvent(Pageable pageable, Long eventId) {
        List<TicketRequestDTO> dtos = this.repository.findAllByEventId(eventId)
                .stream()
                .map(t -> ticketRequestMapper.toResource(t))
                .toList();
        return buildPagination(dtos, pageable);
    }

    @Transactional
    public TicketRequest create(TicketRequest ticketRequest) {
        Event event = eventService.findByCodeOptional(ticketRequest.getCode())
                .orElseThrow(() -> new NotFoundException("Código inválido ou não existe"));
        User requester = userService.findByIdOptional(ticketRequest.getRequester().getId())
                .orElseThrow(() -> new NotFoundException("Usuário solicitante não encontrado pelo id"));
        User requested = userService.findByIdOptional(ticketRequest.getRequester().getId())
                .orElseThrow(() -> new NotFoundException("Usuário solicitado não encontrado pelo id"));

        ticketRequest.setEvent(event);
        ticketRequest.setRequester(requester);
        ticketRequest.setRequested(requested);

        return super.create(ticketRequest);
    }
}
