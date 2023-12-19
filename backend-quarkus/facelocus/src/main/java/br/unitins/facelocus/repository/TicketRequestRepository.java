package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.TicketRequest;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class TicketRequestRepository extends BaseRepository<TicketRequest> {

    public List<TicketRequest> findAllByEventId(Long eventId) {
        return find("FROM TicketRequest WHERE event.id = ?1", eventId).list();
    }
}
