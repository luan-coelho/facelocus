package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.TicketRequest;
import br.unitins.facelocus.model.TicketRequestStatus;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class TicketRequestRepository extends BaseRepository<TicketRequest> {

    public List<TicketRequest> findAllByEventId(Long eventId) {
        return find("FROM TicketRequest WHERE event.id = ?1", eventId).list();
    }

    public TicketRequestStatus getStatusById(Long ticketRequestId) {
        return find("FROM TicketRequest WHERE id = ?1", ticketRequestId).singleResult().getRequestStatus();
    }

    public void updateStatus(Long ticketRequestId, TicketRequestStatus requestStatus) {
        update("UPDATE TicketRequest SET requestStatus = ?2 WHERE id = ?1" , ticketRequestId, requestStatus);
    }
}
