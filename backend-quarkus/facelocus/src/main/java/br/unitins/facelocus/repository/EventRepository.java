package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.Event;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class EventRepository extends BaseRepository<Event> {

    public boolean existsByCode(String code) {
        return count("FROM Event WHERE code = ?1", code) > 0;
    }
}
