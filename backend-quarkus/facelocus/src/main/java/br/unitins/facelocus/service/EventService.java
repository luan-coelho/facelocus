package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.model.Location;
import br.unitins.facelocus.repository.EventRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;

import java.security.SecureRandom;
import java.util.List;

@ApplicationScoped
public class EventService extends BaseService<Event, EventRepository> {

    @Inject
    LocationService locationService;

    /**
     * Busca todos os eventos de maneira paginada, juntamente com seus relacionamentos.
     *
     * @param pageable contem informacoes de paginacao
     * @return lista paginada
     */
    public DataPagination<Event> findAllPaginated(Pageable pageable) {
        List<Event> events = repository.listAll();
        for (Event event : events) {
            List<Location> locations = locationService.findAllByEvent(event);
            event.setLocations(locations);
        }
        return buildPagination(events, pageable);
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

    public String generateUniqueCode() {
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        int codeSize = 6;
        SecureRandom random = new SecureRandom();
        StringBuilder code = new StringBuilder(codeSize);

        for (int i = 0; i < codeSize; i++) {
            int index = random.nextInt(characters.length());
            code.append(characters.charAt(index));
        }

        if (this.repository.existsByCode(code.toString())) {
            code = new StringBuilder(generateUniqueCode());
            return code.toString();
        }
        return code.toString();
    }
}
