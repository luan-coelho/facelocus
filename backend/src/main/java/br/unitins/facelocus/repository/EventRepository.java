package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.Event;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class EventRepository extends BaseRepository<Event> {

    public EventRepository() {
        super(Event.class);
    }

    public List<Event> findAllByUser(Long userId) {
        return find("FROM Event WHERE administrator.id = ?1", userId).list();
    }

    public Event findFirst() {
        return find("FROM Event WHERE id != null").firstResult();
    }

    public Event findWithDifferenId(Long id) {
        return find("FROM Event WHERE id != null AND id <> ?1", id).firstResult();
    }

    public Optional<Event> findByCodeOptional(String code) {
        return find("FROM Event WHERE code = ?1", code).singleResultOptional();
    }

    public boolean existsByCode(String code) {
        return count("FROM Event WHERE code = ?1", code) > 0;
    }

    public void changeTicketRequestPermissionByEventId(Long eventId) {
        update("UPDATE Event SET allowTicketRequests = (NOT allowTicketRequests) WHERE id = ?1", eventId);
    }

    public void updateCodeById(Long eventId, String code) {
        update("UPDATE Event SET code = ?1 WHERE id = ?2", code, eventId);
    }

    public boolean linkedUser(Long eventId, Long userId) {
        return count("FROM Event e JOIN e.users u WHERE e.id = ?1 AND u.id = ?2", eventId, userId) > 0;
    }

    public List<Event> findAllByDescription(Long userId, String description) {
        String query = """
                FROM Event
                WHERE administrator.id = ?1
                    AND FUNCTION('unaccent', LOWER(description)) LIKE FUNCTION('unaccent', LOWER('%'||?2||'%'))
                """;
        return find(query, userId, description).list();
    }
}
