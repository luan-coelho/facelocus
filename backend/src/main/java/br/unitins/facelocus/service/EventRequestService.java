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

import java.util.List;

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
    public DataPagination<?> findAllByEventAndUser(Pageable pageable, Long eventId, Long userId) {
        List<EventRequestResponseDTO> dtos = this.repository.findAllByEventAndUser(eventId, userId)
                .stream()
                .map(t -> eventRequestMapper.toResource(t))
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
        List<EventRequestResponseDTO> dtos = this.repository.findAllByEventId(eventId)
                .stream()
                .map(t -> eventRequestMapper.toResource(t))
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
        List<EventRequestResponseDTO> dtos = this.repository.findAllByUserId(userId)
                .stream()
                .map(t -> eventRequestMapper.toResource(t))
                .toList();
        return buildPagination(dtos, pageable);
    }

    public DataPagination<?> findAllReceivedByUser(Pageable pageable, Long userId) {
        List<EventRequestResponseDTO> dtos = this.repository.findAllReceivedByUser(userId)
                .stream()
                .map(t -> eventRequestMapper.toResource(t))
                .toList();
        return buildPagination(dtos, pageable);
    }

    public DataPagination<?> findAllSentByUser(Pageable pageable, Long userId) {
        List<EventRequestResponseDTO> dtos = this.repository
                .findAllSentByUser(userId)
                .stream()
                .map(t -> eventRequestMapper.toResource(t))
                .toList();
        return buildPagination(dtos, pageable);
    }

    public EventRequest findById(Long id) {
        return repository
                .findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Solicitação de ingresso não encontrada pelo id"));
    }

    @Transactional
    public void createInvitation(EventRequestCreateDTO requestCreateDTO) {
        Event event = eventService.findByIdOptional(requestCreateDTO.event().getId())
                .orElseThrow(() -> new NotFoundException("Evento não encontrado pelo id"));
        User requestOwner = userService.findByIdOptional(requestCreateDTO.requestOwner().getId())
                .orElseThrow(() -> new NotFoundException("Usuário solicitado não encontrado pelo id"));

        User requestor = event.getAdministrator();
        if (requestor.getId().equals(requestCreateDTO.requestOwner().getId())) {
            throw new IllegalArgumentException("O usuário solicitador não pode ser o mesmo solicitado");
        }

        if (eventService.linkedUser(event.getId(), requestOwner.getId())) {
            throw new IllegalArgumentException("Usuário já vinculado ao evento");
        }

        EventRequest eventRequest = eventRequestMapper.toCreateEntity(requestCreateDTO);
        eventRequest.setEvent(event);
        eventRequest.setRequestOwner(requestOwner);
        super.create(eventRequest);
    }

    @Transactional
    public void createTicketRequest(EventRequestCreateDTO requestCreateDTO) {
        Event event = eventService.findByCodeOptional(requestCreateDTO.event().getCode())
                .orElseThrow(() -> new NotFoundException("Código inválido ou não existe"));
        User requestOwner = userService.findByIdOptional(requestCreateDTO.requestOwner().getId())
                .orElseThrow(() -> new NotFoundException("Usuário solicitador não encontrado pelo id"));

        User administrator = event.getAdministrator();
        if (administrator.getId().equals(requestOwner.getId())) {
            throw new IllegalArgumentException("Você é o administrador do evento");
        }

        if (eventService.linkedUser(event.getId(), requestOwner.getId())) {
            throw new IllegalArgumentException("Você já está vinculado ao evento");
        }

        EventRequest eventRequest = eventRequestMapper.toCreateEntity(requestCreateDTO);
        eventRequest.setEvent(event);
        eventRequest.setRequestOwner(requestOwner);
        eventRequest.setRequestType(EventRequestType.TICKET_REQUEST);
        super.create(eventRequest);
    }


    @Transactional
    @Override
    public void deleteById(Long eventRequestId) {
        EventRequest eventRequest = findByIdOptional(eventRequestId)
                .orElseThrow(() -> new NotFoundException("Solicitação de ingresso não encontrada pelo id"));
        EventRequestStatus status = eventRequest.getRequestStatus();
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
     * @param requestStatus  Situação da solicitação
     */
    private void updateInvitationRequestStatus(Long userId, Long eventRequestId, EventRequestStatus requestStatus) {
        EventRequest eventRequest = findById(eventRequestId);
        Long administratorId = eventRequest.getEvent().getAdministrator().getId();
        if (administratorId.equals(userId)) {
            throw new IllegalArgumentException("Você não tem permissão para aceitar ou rejeitar esta solicitação");
        }
        this.repository.updateStatus(eventRequestId, requestStatus);
        eventService.addUserByEventIdAndUserId(eventRequest.getEvent().getId(), eventRequest.getRequestOwner().getId());
    }

    /**
     * Responsável por aprovar uma solicitação de ingresso
     *
     * @param userId         Identificador do usuário solicitado
     * @param eventRequestId Identificador da solicitação de ingresso
     * @param requestStatus  Situação da solicitação
     */
    private void updateTicketRequestStatus(Long userId, Long eventRequestId, EventRequestStatus requestStatus) {
        EventRequest eventRequest = findById(eventRequestId);
        Long requestOwnerId = eventRequest.getRequestOwner().getId();
        if (!requestOwnerId.equals(userId)) {
            throw new IllegalArgumentException("Você não tem permissão para aceitar ou rejeitar esta solicitação");
        }
        this.repository.updateStatus(eventRequestId, requestStatus);
        eventService.addUserByEventIdAndUserId(eventRequest.getEvent().getId(), requestOwnerId);
    }

    @Transactional
    public void approve(Long userId, Long eventRequestId, EventRequestType requestType) {
        if (requestType == EventRequestType.INVITATION) {
            updateInvitationRequestStatus(userId, eventRequestId, EventRequestStatus.APPROVED);
            return;
        }
        updateTicketRequestStatus(userId, eventRequestId, EventRequestStatus.APPROVED);
    }

    @Transactional
    public void reject(Long userId, Long eventRequestId, EventRequestType requestType) {
        if (requestType == EventRequestType.INVITATION) {
            updateInvitationRequestStatus(userId, eventRequestId, EventRequestStatus.REJECTED);
            return;
        }
        updateTicketRequestStatus(userId, eventRequestId, EventRequestStatus.REJECTED);
    }
}
