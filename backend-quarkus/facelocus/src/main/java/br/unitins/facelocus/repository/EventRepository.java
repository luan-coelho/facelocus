package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.Event;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class EventRepository extends BaseRepository<Event> {

    public boolean existsByCode(String code) {
        return count("FROM Event WHERE code = ?1", code) > 0;
    }

    public void changeTicketRequestPermissionByEventId(Long eventId) {
        String query = "UPDATE Event SET allowTicketRequests = (NOT allowTicketRequests) WHERE id = ?1";
        update(query, eventId);
    }

    public void updateCodeById(Long eventId, String code) {
        String query = "UPDATE Event SET code = ?1 WHERE id = ?2";
        update(query, code, eventId);
    }
}
