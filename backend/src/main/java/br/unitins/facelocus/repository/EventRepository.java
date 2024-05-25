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
                SELECT DISTINCT e
                FROM Event e
                    LEFT JOIN e.locations
                WHERE e.administrator.id = ?1
                """;
        PanacheQuery<Event> panacheQuery = find(query, userId);
        return buildDataPagination(pageable, panacheQuery);
    }

    public List<Event> findAllByAdministratorUser(Long userId) {
        // language=jpaql
        String query = """
                SELECT DISTINCT e
                FROM Event e
                    JOIN e.administrator au
                WHERE au.id = ?1
                """;
        return find(query, userId).list();
    }

    public List<Event> findAllByUser(Long userId) {
        // language=jpaql
        String query = """
                SELECT DISTINCT e
                FROM Event e
                    LEFT JOIN e.users u
                WHERE u.id = ?1
                """;
        return find(query, userId).list();
    }

    public DataPagination<Event> findAllByDescription(Pageable pageable, Long userId, String description) {
        // language=jpaql
        String query = """
                SELECT DISTINCT e
                FROM Event e
                WHERE e.administrator.id = ?1
                    AND FUNCTION('unaccent', LOWER(e.description)) LIKE FUNCTION('unaccent', LOWER('%'||?2||'%'))
                """;
        PanacheQuery<Event> panacheQuery = find(query, userId, description);
        return buildDataPagination(pageable, panacheQuery);
    }

    @Override
    public Optional<Event> findByIdOptional(Long pointRecordId) {
        // language=jpaql
        String query = """
                SELECT DISTINCT e
                FROM Event e
                    LEFT JOIN e.locations l
                WHERE e.id = ?1
                """;
        return find(query, pointRecordId).singleResultOptional();
    }

    public Optional<Event> findByCodeOptional(String code) {
        // language=jpaql
        String query = """
                FROM Event
                WHERE code = ?1
                """;
        return find(query, code).singleResultOptional();
    }

    public boolean existsByCode(String code) {
        // language=jpaql
        String query = """
                FROM Event
                WHERE code = ?1
                """;
        return count(query, code) > 0;
    }

    public void changeTicketRequestPermissionByEventId(Long eventId) {
        // language=jpaql
        String query = """
                UPDATE Event
                SET allowTicketRequests = (NOT allowTicketRequests)
                WHERE id = ?1
                """;
        update(query, eventId);
    }

    public void updateCodeById(Long eventId, String code) {
        // language=jpaql
        String query = """
                UPDATE Event
                SET code = ?1
                WHERE id = ?2
                """;
        update(query, code, eventId);
    }

    public boolean linkedUser(Long eventId, Long userId) {
        // language=jpaql
        String query = """
                FROM Event e
                    JOIN e.users u
                WHERE e.id = ?1
                AND u.id = ?2
                """;
        return count(query, eventId, userId) > 0;
    }
}
