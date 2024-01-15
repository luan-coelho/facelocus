package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.TicketRequest;
import br.unitins.facelocus.model.TicketRequestStatus;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class TicketRequestRepository extends BaseRepository<TicketRequest> {

    public TicketRequestRepository() {
        super(TicketRequest.class);
    }

    public List<TicketRequest> findAllByEventId(Long eventId) {
        return find("FROM TicketRequest WHERE event.id = ?1", eventId).list();
    }

    public List<TicketRequest> findAllByUserId(Long userId) {
        String sql = "FROM TicketRequest WHERE event.administrator.id = ?1 OR user.id = ?1";
        return find(sql, userId).list();
    }

    public List<TicketRequest> findAllReceivedByUser(Long userId) {
        return find("FROM TicketRequest WHERE event.administrator.id = ?1", userId).list();
    }

    public List<TicketRequest> findAllSentByUser(Long userId) {
        return find("FROM TicketRequest WHERE user.id = ?1", userId).list();
    }

    public void updateStatus(Long ticketRequestId, TicketRequestStatus requestStatus) {
        update("UPDATE TicketRequest SET requestStatus = ?2 WHERE id = ?1", ticketRequestId, requestStatus);
    }

    public List<TicketRequest> findAllByEventAndUser(Long eventId, Long userId) {
        String sql = "FROM TicketRequest WHERE event.id = ?1 AND event.administrator.id = ?2";
        return find(sql, eventId, userId).list();
    }
}
