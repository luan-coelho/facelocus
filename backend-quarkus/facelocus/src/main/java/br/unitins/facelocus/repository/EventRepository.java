package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.Event;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class EventRepository extends BaseRepository<Event> {

    public boolean existsByCode(String code) {
        return count("FROM Event WHERE code = ?1", code) > 0;
    }

    public void changeTicketRequestPermissionByEventId(Long eventId) {
        update("UPDATE Event SET allowTicketRequests = (NOT allowTicketRequests) WHERE id = ?1", eventId);
    }

    public void updateCodeById(Long eventId, String code) {
        update("UPDATE Event SET code = ?1 WHERE id = ?2", code, eventId);
    }
}
