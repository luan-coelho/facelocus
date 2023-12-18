package br.unitins.facelocus.service;

import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.model.Location;
import br.unitins.facelocus.repository.LocationRepository;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class LocationService extends BaseService<Location, LocationRepository> {

    public List<Location> findAllByEvent(Event evento) {
        return this.repository.findAllByEventId(evento.getId());
    }
}
