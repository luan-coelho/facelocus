package br.unitins.facelocus.resource;

import br.unitins.facelocus.dto.pointrecord.UserAttendanceResponseDTO;
import br.unitins.facelocus.mapper.UserAttendanceMapper;
import br.unitins.facelocus.model.UserAttendance;
import br.unitins.facelocus.service.UserAttendanceService;
import io.quarkus.security.Authenticated;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.core.Response;
import org.jboss.resteasy.reactive.RestQuery;

import java.util.List;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
//@Authenticated
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


    @Path("/by-point-record")
    @GET
    public Response findAllByPointRecord(@RestQuery("pointrecord") Long pointRecordId) {
        List<UserAttendance> userAttendances = userAttendanceService.findAllByPointRecord(pointRecordId);
        List<UserAttendanceResponseDTO> dtos = userAttendanceMapper.toResource(userAttendances);
        return Response.ok(dtos).build();
    }

    @Path("/{id}")
    @GET
    public Response findById(@PathParam("id") Long userAttendanceId) {
        UserAttendance userAttendance = userAttendanceService.findById(userAttendanceId);
        UserAttendanceResponseDTO dto = userAttendanceMapper.toResource(userAttendance);
        return Response.ok(dto).build();
    }
}
