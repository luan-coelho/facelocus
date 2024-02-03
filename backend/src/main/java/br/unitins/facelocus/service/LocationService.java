package br.unitins.facelocus.service;

import br.unitins.facelocus.mapper.LocationMapper;
import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.model.Location;
import br.unitins.facelocus.repository.LocationRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;

@ApplicationScoped
public class LocationService extends BaseService<Location, LocationRepository> {

    @Inject
    LocationMapper locationMapper;

    @Inject
    EventService eventService;

    public List<Location> findAllByEventId(Long eventId) {
        existsById(eventId);
        return this.repository.findAllByEventId(eventId);
    }

    @Transactional
    public Location create(Long locationId, Location location) {
        Event event = eventService.findByIdOptional(locationId)
                .orElseThrow(() -> new NotFoundException("Evento não encontrado pelo id"));
        location.setEvent(event);
        return super.create(location);
    }

    @Transactional
    public Location updateById(Long locationId, Location location) {
        Location locationFound = findById(locationId);
        locationFound = locationMapper.copyProperties(location, locationFound);
        return super.update(locationFound);
    }
}
