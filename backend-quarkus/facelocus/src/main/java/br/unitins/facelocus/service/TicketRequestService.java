package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.ticketrequest.TicketRequestCreateDTO;
import br.unitins.facelocus.dto.ticketrequest.TicketRequestResponseDTO;
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
     * @return Objeto paginável de solicitações de ingresso
     */
    public DataPagination<?> findAllByEventAndUser(Pageable pageable, Long eventId, Long userId) {
        List<TicketRequestResponseDTO> dtos = this.repository.findAllByEventAndUser(eventId, userId)
                .stream()
                .map(t -> ticketRequestMapper.toResource(t))
                .toList();
        return buildPagination(dtos, pageable);
    }

    /**
     * Responsável por buscar todas as solicitações de ingresso vinculadas ao um evento
     *
     * @param pageable Informações de paginação
     * @param eventId  Identificador do evento
     * @return Objeto paginável de solicitações de ingresso
     */
    public DataPagination<?> findAllByEvent(Pageable pageable, Long eventId) {
        List<TicketRequestResponseDTO> dtos = this.repository.findAllByEventId(eventId)
                .stream()
                .map(t -> ticketRequestMapper.toResource(t))
                .toList();
        return buildPagination(dtos, pageable);
    }

    /**
     * Responsável por buscar todas as solicitações de ingresso vinculadas ao um usuário
     *
     * @param pageable Informações de paginação
     * @param userId   Identificador do usuário
     * @return Objeto paginável de solicitações de ingresso
     */
    public DataPagination<?> findAllByUser(Pageable pageable, Long userId) {
        List<TicketRequestResponseDTO> dtos = this.repository.findAllByUserId(userId)
                .stream()
                .map(t -> ticketRequestMapper.toResource(t))
                .toList();
        return buildPagination(dtos, pageable);
    }

    public DataPagination<?> findAllReceivedByUser(Pageable pageable, Long userId) {
        List<TicketRequestResponseDTO> dtos = this.repository.findAllReceivedByUser(userId)
                .stream()
                .map(t -> ticketRequestMapper.toResource(t))
                .toList();
        return buildPagination(dtos, pageable);
    }

    public DataPagination<?> findAllSentByUser(Pageable pageable, Long userId) {
        List<TicketRequestResponseDTO> dtos = this.repository
                .findAllSentByUser(userId)
                .stream()
                .map(t -> ticketRequestMapper.toResource(t))
                .toList();
        return buildPagination(dtos, pageable);
    }

    public TicketRequest findById(Long id) {
        return repository
                .findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Solicitação de ingresso não encontrada pelo id"));
    }

    @Transactional
    public TicketRequest create(TicketRequestCreateDTO ticketRequestCreateDTO) {
        Event event = null;

        if (ticketRequestCreateDTO.event().getId() != null) {
            event = eventService.findByIdOptional(ticketRequestCreateDTO.event().getId())
                    .orElseThrow(() -> new NotFoundException("Evento não encontrado pelo id"));
        }

        if (event == null && ticketRequestCreateDTO.event().getCode() != null) {
            event = eventService.findByCodeOptional(ticketRequestCreateDTO.event().getCode())
                    .orElseThrow(() -> new NotFoundException("Evento não encontrado pelo código"));
        }

        if (event == null) {
            throw new NotFoundException("Evento não encontrado");
        }

        TicketRequest ticketRequest = ticketRequestMapper.toCreateEntity(ticketRequestCreateDTO);

        User administrator = event.getAdministrator();
        Long userRequestedId = ticketRequestCreateDTO.user().getId();

        if (administrator.getId().equals(userRequestedId)) {
            throw new IllegalArgumentException("O usuário solicitante não pode ser o mesmo solicitado");
        }

        if (ticketRequestCreateDTO.event().getCode() != null) {
            boolean existsByCode = eventService.existsByCode(event.getCode());
            if (!existsByCode) {
                throw new NotFoundException("Código de evento inválido ou não existe");
            }
            ticketRequest.setCode(ticketRequestCreateDTO.event().getCode());
        }

        Long eventId = event.getId();
        if (eventService.linkedUser(eventId, userRequestedId)) {
            throw new IllegalArgumentException("Usuário já vinculado ao evento");
        }

        User requested = userService
                .findByIdOptional(userRequestedId)
                .orElseThrow(() -> new NotFoundException("Usuário solicitado não encontrado pelo id"));

        ticketRequest.setEvent(event);
        ticketRequest.setUser(requested);

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
        Long requestedId = ticketRequest.getUser().getId();
        if (!requestedId.equals(userId)) {
            throw new IllegalArgumentException("Você não tem permissão para aceitar ou rejeitar a solicitação");
        }
        this.repository.updateStatus(ticketRequestId, requestStatus);
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
