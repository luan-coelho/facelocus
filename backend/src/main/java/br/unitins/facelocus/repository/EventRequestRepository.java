package br.unitins.facelocus.repository;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.model.EventRequest;
import br.unitins.facelocus.model.EventRequestStatus;
import io.quarkus.hibernate.orm.panache.PanacheQuery;
import io.quarkus.panache.common.Sort;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class EventRequestRepository extends BaseRepository<EventRequest> {

    public EventRequestRepository() {
        super(EventRequest.class);
    }

    public DataPagination<EventRequest> findAllByEventId(Pageable pageable, Long eventId) {
        // language=jpaql
        String query = """
                FROM EventRequest
                WHERE event.id = ?1
                """;
        PanacheQuery<EventRequest> panacheQuery = find(query, eventId);
        return buildDataPagination(pageable, panacheQuery);
    }

    public List<EventRequest> findAllByUserId(Long userId) {
        // language=jpaql
        String query = """
                FROM EventRequest
                WHERE initiatorUser.id = ?1
                """;
        PanacheQuery<EventRequest> panacheQuery = find(query, userId);
        return panacheQuery.list();
    }

    public List<EventRequest> findAllByEventId(Long eventId) {
        // language=jpaql
        String query = """
                FROM EventRequest
                WHERE event.id = ?1
                """;
        PanacheQuery<EventRequest> panacheQuery = find(query, eventId);
        return panacheQuery.list();
    }

    public DataPagination<EventRequest> findAllByUserId(Pageable pageable, Long userId) {
        // language=jpaql
        String query = """
                FROM EventRequest er
                WHERE er.event.administrator.id = ?1
                    OR er.initiatorUser.id = ?1
                    OR er.targetUser.id = ?1
                """;
        PanacheQuery<EventRequest> panacheQuery = find(query, Sort.descending("createdAt"), userId);
        return buildDataPagination(pageable, panacheQuery);
    }

    public DataPagination<EventRequest> findAllReceivedByUser(Pageable pageable, Long userId) {
        // language=jpaql
        String query = """
                FROM EventRequest
                WHERE event.administrator.id = ?1
                """;
        PanacheQuery<EventRequest> panacheQuery = find(query, userId);
        return buildDataPagination(pageable, panacheQuery);
    }

    public DataPagination<EventRequest> findAllSentByUser(Pageable pageable, Long userId) {
        // language=jpaql
        String query = """
                FROM EventRequest
                WHERE initiatorUser.id = ?1
                """;
        PanacheQuery<EventRequest> panacheQuery = find(query, userId);
        return buildDataPagination(pageable, panacheQuery);
    }

    public DataPagination<EventRequest> findAllByEventAndUser(Pageable pageable, Long eventId, Long userId) {
        // language=jpaql
        String query = """
                FROM EventRequest
                WHERE event.id = ?1
                    AND event.administrator.id = ?2
                """;
        PanacheQuery<EventRequest> panacheQuery = find(query, eventId, userId);
        return buildDataPagination(pageable, panacheQuery);
    }

    public void updateStatus(Long eventRequestId, EventRequestStatus status) {
        update("UPDATE EventRequest SET status = ?2 WHERE id = ?1", eventRequestId, status);
    }
}
