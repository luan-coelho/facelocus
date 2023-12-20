package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.TicketRequestDTO;
import br.unitins.facelocus.mapper.TicketRequestMapper;
import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.model.TicketRequest;
import br.unitins.facelocus.model.TicketRequestStatus;
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

    /**
     * Responsável por buscar todas as solicitações de ingresso vinculadas ao um evento
     *
     * @param pageable Informações de paginação
     * @param eventId  Identificador do evento
     * @return Objeto paginável de solicitações de ingresso
     */
    public DataPagination<?> findAllPaginatedByEvent(Pageable pageable, Long eventId) {
        List<TicketRequestDTO> dtos = this.repository.findAllByEventId(eventId)
                .stream()
                .map(t -> ticketRequestMapper.toResource(t))
                .toList();
        return buildPagination(dtos, pageable);
    }

    public TicketRequest findById(Long id) {
        return repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Solicitação de ingresso não encontrada pelo id"));
    }

    @Transactional
    public TicketRequest create(TicketRequest ticketRequest) {
        Long requestedId = ticketRequest.getRequested().getId();
        if (ticketRequest.getRequester().getId() != null && ticketRequest.getRequester().getId().equals(requestedId)) {
            throw new IllegalArgumentException("O usuário solicitante não pode ser o mesmo solicitado");
        }

        Event event = eventService
                .findByCodeOptional(ticketRequest.getCode())
                .orElseThrow(() -> new NotFoundException("Código inválido ou não existe"));

        Long eventId = event.getId();
        if (eventService.linkedUser(eventId, requestedId)) {
            throw new IllegalArgumentException("Usuário já vinculado ao evento");
        }

        User requester = userService
                .findByIdOptional(ticketRequest.getRequester().getId())
                .orElseThrow(() -> new NotFoundException("Usuário solicitante não encontrado pelo id"));
        User requested = userService
                .findByIdOptional(requestedId)
                .orElseThrow(() -> new NotFoundException("Usuário solicitado não encontrado pelo id"));

        ticketRequest.setEvent(event);
        ticketRequest.setRequester(requester);
        ticketRequest.setRequested(requested);

        return super.create(ticketRequest);
    }

    @Transactional
    @Override
    public void deleteById(Long ticketRequestId) {
        TicketRequest ticketRequest = findByIdOptional(ticketRequestId)
                .orElseThrow(() -> new NotFoundException("Solicitação de ingresso não encontrada pelo id"));
        TicketRequestStatus status = ticketRequest.getRequestStatus();
        if (status != TicketRequestStatus.PENDING) {
            String message = "A solicitação não está mais pendente. Desta forma, ela não pode ser apagada";
            throw new IllegalArgumentException(message);
        }
        super.deleteById(ticketRequestId);
    }

    /**
     * Responsável por aprovar uma solicitação de ingresso
     *
     * @param userId          Identificador do usuário solicitado
     * @param ticketRequestId Identificador da solicitação de ingresso
     * @param requestStatus   Situação da solicitação
     */
    private void updateStatus(Long userId, Long ticketRequestId, TicketRequestStatus requestStatus) {
        TicketRequest ticketRequest = findById(ticketRequestId);
        Long requestedId = ticketRequest.getRequested().getId();
        if (!requestedId.equals(userId)) {
            throw new IllegalArgumentException("Você não tem permissão para aceitar ou rejeitar a solicitação");
        }
        this.repository.updateStatus(requestedId, requestStatus);
        eventService.addUserByEventIdAndUserId(ticketRequest.getEvent().getId(), requestedId);
    }

    @Transactional
    public void approve(Long userId, Long ticketRequestId) {
        updateStatus(userId, ticketRequestId, TicketRequestStatus.APPROVED);
    }

    @Transactional
    public void reject(Long userId, Long ticketRequestId) {
        updateStatus(userId, ticketRequestId, TicketRequestStatus.REJECTED);
    }
}
