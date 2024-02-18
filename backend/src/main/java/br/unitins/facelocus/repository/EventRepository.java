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
        // language=jpaql
        String query = """
                FROM Event e
                    LEFT JOIN e.locations
                WHERE e.administrator.id = ?1
                """;
        PanacheQuery<Event> panacheQuery = find(query, userId);
        return buildDataPagination(pageable, panacheQuery);
    }

    public List<Event> findAllByUser(Long userId) {
        // language=jpaql
        String query = """
                FROM Event e
                    LEFT JOIN e.users u
                WHERE u.id = ?1
                """;
        return find(query, userId).list();
    }

    public DataPagination<Event> findAllByDescription(Pageable pageable, Long userId, String description) {
        String query = """
                FROM Event
                WHERE administrator.id = ?1
                    AND FUNCTION('unaccent', LOWER(description)) LIKE FUNCTION('unaccent', LOWER('%'||?2||'%'))
                """;
        PanacheQuery<Event> panacheQuery = find(query, userId, description);
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
}
