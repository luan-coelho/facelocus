package br.unitins.facelocus.repository;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.model.Event;
import io.quarkus.hibernate.orm.panache.PanacheQuery;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class EventRepository extends BaseRepository<Event> {

    public EventRepository() {
        super(Event.class);
    }

    public DataPagination<Event> findAllByUser(Pageable pageable, Long userId) {
        String query = """
                FROM Event e
                JOIN Location l ON l.event.id = e.id
                WHERE e.administrator.id = ?1
                """;
        PanacheQuery<Event> panacheQuery = find(query, userId);
        return buildDataPagination(pageable, panacheQuery);
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
