package br.unitins.facelocus.dto.pointrecord;

import java.time.LocalDate;
import java.util.List;
import java.util.Set;

import br.unitins.facelocus.dto.event.LocationDTO;
import br.unitins.facelocus.dto.event.PointDTO;
import br.unitins.facelocus.dto.eventrequest.EventWithoutRelationshipsDTO;
import br.unitins.facelocus.model.Factor;

public record PointRecordResponseDTO(Long id,
        EventWithoutRelationshipsDTO event,
        LocalDate date,
        LocationDTO location,
        List<PointDTO> points,
        Set<Factor> factors,
        Double allowableRadiusInMeters,
        boolean inProgress,
        List<UserAttendanceResponseDTO> usersAttendances) {
}
