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

    @Override
    public Location findById(Long locationId) {
        return super.findByIdOptional(locationId)
                .orElseThrow(() -> new NotFoundException("Localização não encontrada pelo id"));
    }

    @Transactional
    public Location create(Long locationId, Location location) {
        Event event = eventService.findById(locationId);
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
