package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.eventrequest.EventRequestCreateDTO;
import br.unitins.facelocus.dto.eventrequest.EventRequestResponseDTO;
import br.unitins.facelocus.mapper.EventRequestMapper;
import br.unitins.facelocus.model.*;
import br.unitins.facelocus.repository.EventRequestRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

@ApplicationScoped
public class EventRequestService extends BaseService<EventRequest, EventRequestRepository> {

    @Inject
    EventRequestMapper eventRequestMapper;

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
    public DataPagination<EventRequestResponseDTO> findAllByEventAndUser(Pageable pageable, Long eventId, Long userId) {
        DataPagination<EventRequest> dataPagination = this.repository.findAllByEventAndUser(pageable, eventId, userId);
        return eventRequestMapper.toCreateEntity(dataPagination);
    }

    /**
     * Responsável por buscar todas as solicitações de ingresso vinculadas ao um evento
     *
     * @param pageable Informações de paginação
     * @param eventId  Identificador do evento
     * @return Objeto paginável de solicitações de ingresso
     */
    public DataPagination<EventRequestResponseDTO> findAllByEvent(Pageable pageable, Long eventId) {
        DataPagination<EventRequest> dataPagination = this.repository.findAllByEventId(pageable, eventId);
        return eventRequestMapper.toCreateEntity(dataPagination);
    }

    /**
     * Responsável por buscar todas as solicitações de ingresso vinculadas ao um usuário
     *
     * @param pageable Informações de paginação
     * @param userId   Identificador do usuário
     * @return Objeto paginável de solicitações de ingresso
     */
    public DataPagination<EventRequestResponseDTO> findAllByUser(Pageable pageable, Long userId) {
        DataPagination<EventRequest> dataPagination = this.repository.findAllByUserId(pageable, userId);
        return eventRequestMapper.toCreateEntity(dataPagination);
    }

    public DataPagination<EventRequestResponseDTO> findAllReceivedByUser(Pageable pageable, Long userId) {
        DataPagination<EventRequest> dataPagination = this.repository.findAllReceivedByUser(pageable, userId);
        return eventRequestMapper.toCreateEntity(dataPagination);
    }

    public DataPagination<EventRequestResponseDTO> findAllSentByUser(Pageable pageable, Long userId) {
        DataPagination<EventRequest> dataPagination = this.repository.findAllSentByUser(pageable, userId);
        return eventRequestMapper.toCreateEntity(dataPagination);
    }

    public EventRequest findById(Long id) {
        return repository
                .findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Solicitação não encontrada pelo id"));
    }

    @Transactional
    public void createInvitation(EventRequestCreateDTO requestCreateDTO) {
        Event event = eventService.findById(requestCreateDTO.event().getId());
        User targetUser = userService.findById(requestCreateDTO.targetUser().getId());
        User initialUser = event.getAdministrator();

        if (initialUser.getId().equals(targetUser.getId())) {
            throw new IllegalArgumentException("O usuário solicitador não pode ser o mesmo solicitado");
        }

        if (eventService.linkedUser(event.getId(), targetUser.getId())) {
            throw new IllegalArgumentException("Usuário já vinculado ao evento");
        }

        EventRequest eventRequest = eventRequestMapper.toCreateEntity(requestCreateDTO);
        eventRequest.setEvent(event);
        eventRequest.setInitiatorUser(initialUser);
        eventRequest.setTargetUser(targetUser);
        super.create(eventRequest);
    }

    @Transactional
    public EventRequest createTicketRequest(EventRequestCreateDTO requestCreateDTO) {
        Event event = eventService.findByCode(requestCreateDTO.event().getCode());
        User initiatorUser = userService.findById(requestCreateDTO.initiatorUser().getId());
        User administrator = event.getAdministrator();

        if (administrator.getId().equals(initiatorUser.getId())) {
            throw new IllegalArgumentException("Você é o administrador do evento");
        }

        if (eventService.linkedUser(event.getId(), initiatorUser.getId())) {
            throw new IllegalArgumentException("Você já está vinculado ao evento");
        }

        EventRequest eventRequest = eventRequestMapper.toCreateEntity(requestCreateDTO);
        eventRequest.setEvent(event);
        eventRequest.setCode(event.getCode());
        eventRequest.setInitiatorUser(initiatorUser);
        eventRequest.setTargetUser(event.getAdministrator());
        eventRequest.setType(EventRequestType.TICKET_REQUEST);
        return super.create(eventRequest);
    }


    @Transactional
    @Override
    public void deleteById(Long eventRequestId) {
        EventRequest eventRequest = findById(eventRequestId);
        EventRequestStatus status = eventRequest.getStatus();

        if (status != EventRequestStatus.PENDING) {
            String message = "A solicitação não está mais pendente. Desta forma, ela não pode ser apagada";
            throw new IllegalArgumentException(message);
        }

        super.deleteById(eventRequestId);
    }

    /**
     * Responsável por aprovar um convite
     *
     * @param userId         Identificador do usuário solicitado
     * @param eventRequestId Identificador da solicitação de ingresso
     */
    private void updateInvitationRequestStatus(Long userId, Long eventRequestId) {
        EventRequest eventRequest = findById(eventRequestId);
        Long administratorId = eventRequest.getEvent().getAdministrator().getId();
        Long targetUserId = eventRequest.getTargetUser().getId();

        if (administratorId.equals(userId) || !targetUserId.equals(userId)) {
            throw new IllegalArgumentException("Você não tem permissão para aceitar ou rejeitar esta solicitação");
        }

        eventRequest.setStatus(EventRequestStatus.APPROVED);
        update(eventRequest);
        eventService.addUserByEventIdAndUserId(eventRequest.getEvent().getId(), targetUserId);
    }

    /**
     * Responsável por aprovar uma solicitação de ingresso
     *
     * @param userId         Identificador do usuário solicitado
     * @param eventRequestId Identificador da solicitação de ingresso
     */
    private void updateTicketRequestStatus(Long userId, Long eventRequestId) {
        EventRequest eventRequest = findById(eventRequestId);
        Long initialUserId = eventRequest.getInitiatorUser().getId();
        Long targetUserId = eventRequest.getTargetUser().getId();

        if (!eventRequest.getEvent().isAllowTicketRequests()) {
            throw new IllegalArgumentException("O evento não permite envio de solicitações");
        }

        if (!targetUserId.equals(userId)) {
            throw new IllegalArgumentException("Você não tem permissão para aceitar ou rejeitar esta solicitação");
        }

        eventRequest.setStatus(EventRequestStatus.APPROVED);
        update(eventRequest);
        eventService.addUserByEventIdAndUserId(eventRequest.getEvent().getId(), initialUserId);
    }

    @Transactional
    public void approve(Long userId, Long eventRequestId, EventRequestType requestType) {
        if (requestType == EventRequestType.INVITATION) {
            updateInvitationRequestStatus(userId, eventRequestId);
        } else {
            updateTicketRequestStatus(userId, eventRequestId);
        }
    }

    @Transactional
    public void reject(Long eventRequestId) {
        EventRequest eventRequest = findById(eventRequestId);
        eventRequest.setStatus(EventRequestStatus.REJECTED);
        update(eventRequest);
    }
}
