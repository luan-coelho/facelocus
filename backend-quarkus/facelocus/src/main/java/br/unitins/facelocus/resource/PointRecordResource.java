package br.unitins.facelocus.resource;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.PointRecordDTO;
import br.unitins.facelocus.dto.ticketrequest.PointRecordResponseDTO;
import br.unitins.facelocus.mapper.PointRecordMapper;
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
    public Response findAllByUser(Pageable pageable, @RestQuery("user") Long userId) {
        DataPagination<?> dataPagination = pointRecordService.findAllByUser(pageable, userId);
        return Response.ok(dataPagination).build();
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
}
