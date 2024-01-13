package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.EventDTO;
import br.unitins.facelocus.mapper.EventMapper;
import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.model.Location;
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
    LocationService locationService;

    @Inject
    UserService userService;

    public DataPagination<?> findAllPaginated(Pageable pageable) {
        List<Event> events = repository.listAll();
        for (Event event : events) {
            List<Location> locations = locationService.findAllByEventId(event.getId());
            event.setLocations(locations);
        }
        List<EventDTO> dtos = events.stream().map(event -> eventMapper.toResource(event)).toList();
        return buildPagination(dtos, pageable);
    }

    @Override
    public Event findById(Long eventId) {
        Event event = super.findById(eventId);
        List<Location> locations = locationService.findAllByEventId(eventId);
        List<User> users = userService.findAllByEventId(eventId);
        event.setLocations(locations);
        event.setUsers(users);
        return event;
    }

    @Override
    public Optional<Event> findByIdOptional(Long eventId) {
        return Optional.ofNullable(findById(eventId));
    }

    public Optional<Event> findByCodeOptional(String code) {
        return this.repository.findByCodeOptional(code);
    }

    @Transactional
    @Override
    public Event create(Event event) {
        if (event.isAllowTicketRequests()) {
            event.setCode(generateUniqueCode());
        }
        if (event.getLocations() != null) {
            for (Location location : event.getLocations()) {
                location.setEvent(event);
            }
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
            findByIdOptional(eventId)
                    .orElseThrow(() -> new NotFoundException("Evento não encontrado pelo id"));
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
        Event event = findByIdOptional(eventId)
                .orElseThrow(() -> new NotFoundException("Evento não encontrado pelo id"));
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
        User user = userService.findByIdOptional(userId)
                .orElseThrow(() -> new NotFoundException("Usuário não encontrado pelo id"));
        Event event = findByIdOptional(eventId)
                .orElseThrow(() -> new NotFoundException("Evento não encontrado pelo id"));
        event.getUsers().forEach(u -> {
            if (u.getId().equals(userId))
                throw new IllegalArgumentException("Usuário já vinculado ao evento");
        });
        event.getUsers().add(user);
        update(event);
    }

    public boolean linkedUser(Long eventId, Long userId) {
        return this.repository.linkedUser(eventId, userId);
    }

    @Transactional
    public void removeUser(Long eventId, Long userId) {
        userService.existsByIdWithThrows(userId);
        Event event = findByIdOptional(eventId)
                .orElseThrow(() -> new NotFoundException("Evento não encontrado pelo id"));
        event.getUsers().removeIf(user -> user.getId().equals(userId));
        update(event);
    }
}
