package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.Location;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class LocationRepository extends BaseRepository<Location> {

    public List<Location> findAllByEventId(Long eventId) {
        return find("FROM Location WHERE event.id = ?1", eventId).list();
    }
}
