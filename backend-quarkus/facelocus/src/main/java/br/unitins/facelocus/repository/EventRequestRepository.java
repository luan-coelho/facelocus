package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.EventRequest;
import br.unitins.facelocus.model.EventRequestStatus;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class EventRequestRepository extends BaseRepository<EventRequest> {

    public EventRequestRepository() {
        super(EventRequest.class);
    }

    public List<EventRequest> findAllByEventId(Long eventId) {
        return find("FROM EventRequest WHERE event.id = ?1", eventId).list();
    }

    public List<EventRequest> findAllByUserId(Long userId) {
        String sql = "FROM EventRequest WHERE event.administrator.id = ?1 OR requestOwner.id = ?1";
        return find(sql, userId).list();
    }

    public List<EventRequest> findAllReceivedByUser(Long userId) {
        return find("FROM EventRequest WHERE event.administrator.id = ?1", userId).list();
    }

    public List<EventRequest> findAllSentByUser(Long userId) {
        return find("FROM EventRequest WHERE requestOwner.id = ?1", userId).list();
    }

    public void updateStatus(Long eventRequestId, EventRequestStatus requestStatus) {
        update("UPDATE EventRequest SET requestStatus = ?2 WHERE id = ?1", eventRequestId, requestStatus);
    }

    public List<EventRequest> findAllByEventAndUser(Long eventId, Long userId) {
        String sql = "FROM EventRequest WHERE event.id = ?1 AND event.administrator.id = ?2";
        return find(sql, eventId, userId).list();
    }
}
