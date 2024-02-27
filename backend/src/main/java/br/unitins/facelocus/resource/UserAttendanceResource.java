package br.unitins.facelocus.resource;

import br.unitins.facelocus.dto.pointrecord.UserAttendanceResponseDTO;
import br.unitins.facelocus.mapper.UserAttendanceMapper;
import br.unitins.facelocus.model.UserAttendance;
import br.unitins.facelocus.service.UserAttendanceService;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.core.Response;
import org.jboss.resteasy.reactive.RestQuery;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
@PermitAll
@Path("/user-attendance")
public class UserAttendanceResource {

    @Inject
    UserAttendanceService userAttendanceService;

    @Inject
    UserAttendanceMapper userAttendanceMapper;

    @GET
    public Response findByPointRecordAndUser(@RestQuery("pointrecord") Long pointRecordId, @RestQuery("user") Long userId) {
        UserAttendance userAttendances = userAttendanceService.findByPointRecordAndUser(pointRecordId, userId);
        UserAttendanceResponseDTO dto = userAttendanceMapper.toResource(userAttendances);
        return Response.ok(dto).build();
    }

    @Path("/{id}")
    @GET
    public Response findById(@PathParam("id") Long userAttendanceId) {
        UserAttendance userAttendance = userAttendanceService.findById(userAttendanceId);
        UserAttendanceResponseDTO dto = userAttendanceMapper.toResource(userAttendance);
        return Response.ok(dto).build();
    }
}
