package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.eventrequest.EventDTO;
import br.unitins.facelocus.mapper.EventMapper;
import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.model.PointRecord;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.repository.EventRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;
import org.hibernate.exception.ConstraintViolationException;

import java.security.SecureRandom;
import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class EventService extends BaseService<Event, EventRepository> {

    @Inject
    EventMapper eventMapper;

    @Inject
    UserService userService;

    @Inject
    PointRecordService pointRecordService;

    public DataPagination<EventDTO> findAllPaginatedByUser(Pageable pageable, Long userId) {
        DataPagination<Event> dataPagination = this.repository.findAllByUser(pageable, userId);
        return eventMapper.toResource(dataPagination);
    }

    public DataPagination<EventDTO> findAllByDescription(Pageable pageable, Long userId, String description) {
        DataPagination<Event> dataPagination = this.repository.findAllByDescription(pageable, userId, description);
        return eventMapper.toResource(dataPagination);
    }

    public List<Event> findAllByUser(Long userId) {
        return this.repository.findAllByUser(userId);
    }

    public List<Event> findAllByAdministratorUser(Long userId) {
        return this.repository.findAllByAdministratorUser(userId);
    }

    @Override
    public Event findById(Long eventId) {
        return this.repository
                .findByIdOptional(eventId)
                .orElseThrow(() -> new NotFoundException("Evento não encontrado pelo id"));
    }

    @Override
    public Optional<Event> findByIdOptional(Long eventId) {
        return Optional.ofNullable(findById(eventId));
    }

    public Event findByCode(String code) {
        return this.repository
                .findByCodeOptional(code)
                .orElseThrow(() -> new NotFoundException("Código inválido ou não existe"));
    }

    @Transactional
    @Override
    public Event create(Event event) {
        if (event.isAllowTicketRequests()) {
            event.setCode(generateUniqueCode());
        }

        if (event.getLocations() != null) {
            event.getLocations().forEach(l -> l.setEvent(event));
        }

        return super.create(event);
    }

    @Transactional
    public Event updateById(Long eventId, Event event) {
        Event eventFound = findById(eventId);
        eventFound = eventMapper.toUpdateEntity(event, eventFound);
        return super.update(eventFound);
    }

    @Transactional
    @Override
    public void deleteById(Long eventId) {
        try {
            findById(eventId);
            this.repository.deleteEntityById(eventId);
        } catch (ConstraintViolationException e) {
            throw new IllegalArgumentException("O evento não pode ser deletado pois está vinculado a outros registros");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Gera um código único de 6 dígitos para um evento.
     *
     * @return Código
     */
    private String generateUniqueCode() {
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        int codeSize = 6;
        SecureRandom random = new SecureRandom();
        StringBuilder code = new StringBuilder(codeSize);

        for (int i = 0; i < codeSize; i++) {
            int index = random.nextInt(characters.length());
            code.append(characters.charAt(index));
        }

        if (this.repository.existsByCode(code.toString())) {
            return generateUniqueCode();
        }

        return code.toString();
    }

    /**
     * Habilita ou desabilita, possibilidade para outros usúarios realizarem
     * solicitações de ingresso.
     *
     * @param eventId Identificador do evento
     */
    @Transactional
    public void changeTicketRequestPermissionByEventId(Long eventId) {
        Event event = findById(eventId);

        if (event.getCode() == null) {
            event.setCode(generateUniqueCode());
        }

        this.repository.changeTicketRequestPermissionByEventId(eventId);
    }

    /**
     * Atribui um novo código para um evento
     *
     * @param eventId Identificador do evento
     */
    @Transactional
    public void generateNewCode(Long eventId) {
        existsByIdWithThrows(eventId);
        String code = generateUniqueCode();
        this.repository.updateCodeById(eventId, code);
    }

    /**
     * Responsável por adicionar um usuário a um evento
     *
     * @param eventId Identificador do evento
     * @param userId  Identificador do usuário
     */
    @Transactional
    public void addUserByEventIdAndUserId(Long eventId, Long userId) {
        User user = userService.findById(userId);
        Event event = findById(eventId);
        event.getUsers().forEach(u -> {
            if (u.getId().equals(userId)) throw new IllegalArgumentException("Usuário já vinculado ao evento");
        });
        event.getUsers().add(user);
        update(event);

        List<PointRecord> prs = pointRecordService.findAllByEvent(eventId);
        for (PointRecord pr : prs) {
            pointRecordService.createUsersAttendancesByPointRecord(pr.getId(), userId);
        }
    }

    /**
     * Verifica se o usuário está vinculado ao evento
     *
     * @param eventId Identificador do evento
     * @param userId  Identificador do usuário
     * @return Verdadeiro caso o usuário estiver vinculado e falso caso não
     */
    public boolean linkedUser(Long eventId, Long userId) {
        return this.repository.linkedUser(eventId, userId);
    }

    /**
     * Remove um usuário de um evento
     *
     * @param eventId Identificador do evento
     * @param userId  Identificador do usuário
     */
    @Transactional
    public void removeUser(Long eventId, Long userId) {
        userService.existsByIdWithThrows(userId);
        Event event = findById(eventId);
        event.getUsers().removeIf(user -> user.getId().equals(userId));
        update(event);
        pointRecordService.unlinkUserFromAll(userId);
    }

    /**
     * Remove o usuário de todos os eventos que ele está vinculado
     *
     * @param userId Identificador do usuário
     */
    @Transactional
    public void unlinkUserFromAll(Long userId) {
        List<Event> events = this.repository.findAllByUser(userId);

        for (Event event : events) {
            for (User user : event.getUsers()) {
                if (user.getId().equals(userId)) {
                    pointRecordService.unlinkUserFromAll(userId);
                    event.getUsers().remove(user);
                    this.update(event);
                    break;
                }
            }
        }
    }
}
