package br.unitins.facelocus.resource;

import java.util.List;

import org.jboss.resteasy.reactive.RestQuery;

import br.unitins.facelocus.dto.event.LocationDTO;
import br.unitins.facelocus.mapper.LocationMapper;
import br.unitins.facelocus.model.Location;
import br.unitins.facelocus.service.LocationService;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.DELETE;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.PUT;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.core.Response;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
@Authenticated
@Path("/event-location")
public class LocationResource {

    @Inject
    LocationService locationService;

    @Inject
    LocationMapper locationMapper;

    @GET
    public Response findAll(@RestQuery("event") Long eventId) {
        List<LocationDTO> dtos = locationService.findAllByEventId(eventId)
                .stream()
                .map(location -> locationMapper.toResource(location))
                .toList();
        return Response.ok(dtos).build();
    }

    @Path("/{id}")
    @GET
    public Response findById(@PathParam("id") Long locationId) {
        Location location = locationService.findById(locationId);
        LocationDTO dto = locationMapper.toResource(location);
        return Response.ok(dto).build();
    }

    @POST
    public Response create(@RestQuery("event") Long eventId, @Valid LocationDTO locationDTO) {
        Location location = locationMapper.toCreateEntity(locationDTO);
        location = locationService.create(eventId, location);
        LocationDTO dto = locationMapper.toResource(location);
        return Response.status(Response.Status.CREATED).entity(dto).build();
    }

    @Path("/{id}")
    @PUT
    public Response updateById(@PathParam("id") Long locationId, LocationDTO locationDTO) {
        Location location = locationMapper.toUpdateEntity(locationDTO);
        location = locationService.updateById(locationId, location);
        LocationDTO dto = locationMapper.toResource(location);
        return Response.ok(dto).build();
    }

    @Path("/{id}")
    @DELETE
    public Response deleteById(@PathParam("id") Long locationId) {
        locationService.deleteById(locationId);
        return Response.noContent().build();
    }
}
