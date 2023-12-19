package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.EventDTO;
import br.unitins.facelocus.mapper.EventMapper;
import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.model.Location;
import br.unitins.facelocus.repository.EventRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;

import java.security.SecureRandom;
import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class EventService extends BaseService<Event, EventRepository> {

    @Inject
    EventMapper eventMapper;

    @Inject
    LocationService locationService;

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
        event.setLocations(locations);
        return event;
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
        for (Location location : event.getLocations()) {
            location.setEvent(event);
        }
        return super.create(event);
    }

    @Transactional
    public Event updateById(Long eventId, Event event) {
        Event eventFound = findById(eventId);
        eventFound = eventMapper.toUpdateEntity(event, eventFound);
        return super.update(eventFound);
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
     * Habilita ou desabilita, possibilidade para outros usúarios realizarem solicitações de ingresso.
     *
     * @param eventId Identificador do evento
     */
    @Transactional
    public void changeTicketRequestPermissionByEventId(Long eventId) {
        existsByIdWithThrows(eventId);
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
}
