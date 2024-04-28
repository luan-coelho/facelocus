package br.unitins.facelocus.resource;

import br.unitins.facelocus.dto.pointrecord.AttendanceRecordResponseDTO;
import br.unitins.facelocus.mapper.AttendanceRecordMapper;
import br.unitins.facelocus.model.AttendanceRecord;
import br.unitins.facelocus.service.AttendanceRecordService;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.core.Response;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
@Authenticated
@Path("/attendance-record")
public class AttendanceRecordResource {

    @Inject
    AttendanceRecordService attendanceRecordService;

    @Inject
    AttendanceRecordMapper attendanceRecordMapper;

    @Path("/{id}")
    @GET
    public Response findById(@PathParam("id") Long attendanceRecordId) {
        AttendanceRecord attendanceRecord = attendanceRecordService.findById(attendanceRecordId);
        AttendanceRecordResponseDTO dto = attendanceRecordMapper.toResource(attendanceRecord);
        return Response.ok(dto).build();
    }
}
