package br.unitins.facelocus.resource;

import br.unitins.facelocus.commons.MultipartData;
import br.unitins.facelocus.dto.pointrecord.LocationValidationAttemptDTO;
import br.unitins.facelocus.dto.pointrecord.PointRecordDTO;
import br.unitins.facelocus.dto.pointrecord.PointRecordResponseDTO;
import br.unitins.facelocus.mapper.PointRecordMapper;
import br.unitins.facelocus.model.AttendanceRecord;
import br.unitins.facelocus.model.PointRecord;
import br.unitins.facelocus.service.PointRecordService;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Response;
import org.jboss.resteasy.reactive.RestQuery;

import java.time.LocalDate;
import java.util.List;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
@Authenticated
@Path("/point-record")
public class PointRecordResource {

    @Inject
    PointRecordService pointRecordService;

    @Inject
    PointRecordMapper pointRecordMapper;

    @GET
    public Response findAllByUser(@RestQuery("user") Long userId) {
        List<PointRecordResponseDTO> prs = pointRecordMapper.toResource(pointRecordService.findAllByUser(userId));
        return Response.ok(prs).build();
    }

    @Path("/by-date")
    @GET
    public Response findAllByDate(@RestQuery("user") Long userId, @RestQuery("date") LocalDate date) {
        List<PointRecordResponseDTO> dtos = pointRecordService.findAllByDate(userId, date)
                .stream()
                .map(pr -> pointRecordMapper.toResource(pr))
                .toList();
        return Response.ok(dtos).build();
    }

    @Path("/{id}")
    @GET
    public Response findById(@PathParam("id") Long pointRecordId) {
        PointRecord pointRecord = pointRecordService.findById(pointRecordId);
        PointRecordResponseDTO dto = pointRecordMapper.toResource(pointRecord);
        return Response.ok(dto).build();
    }

    @POST
    public Response create(@Valid PointRecordDTO pointRecordDTO) {
        PointRecord pointRecord = pointRecordMapper.toEntity(pointRecordDTO);
        pointRecord = pointRecordService.create(pointRecord);
        PointRecordResponseDTO dto = pointRecordMapper.toResource(pointRecord);
        return Response.status(Response.Status.CREATED).entity(dto).build();
    }

    @Path("/{id}")
    @DELETE
    public Response deleteById(@PathParam("id") Long pointRecordId) {
        pointRecordService.deleteById(pointRecordId);
        return Response.noContent().build();
    }

    @Path("/change-location")
    @PATCH
    public Response changeLocation(@RestQuery("pointrecord") Long pointRecordId, @RestQuery("location") Long locationId) {
        pointRecordService.changeLocation(pointRecordId, locationId);
        return Response.noContent().build();
    }

    @Path("/change-date")
    @PATCH
    public Response changeDate(@RestQuery("pointrecord") Long pointRecordId, @RestQuery("date") LocalDate newDate) {
        pointRecordService.changeDate(pointRecordId, newDate);
        return Response.noContent().build();
    }

    @Path("/validate-user-points")
    @POST
    public Response validateUserPoints(List<AttendanceRecord> attendancesRecord) {
        pointRecordService.validateUserPoints(attendancesRecord);
        return Response.noContent().build();
    }

    @Path("/validate-lf")
    @POST
    public Response validateLocationFactor(@RestQuery("attendanceRecord") Long attendanceRecordId,
                                           LocationValidationAttemptDTO attemptDto) {
        pointRecordService.validateLocationFactorForAttendanceRecord(attendanceRecordId, attemptDto);
        return Response.ok().build();
    }

    @Path("/validate-frf")
    @POST
    public Response validateFacialRecognitionFactor(@RestQuery("attendanceRecord") Long attendanceRecordId,
                                                    @Valid MultipartData multipartData) {
        pointRecordService.validateFacialRecognitionFactorForAttendanceRecord(attendanceRecordId, multipartData);
        return Response.ok().build();
    }
}
