package br.unitins.facelocus.dto.pointrecord;

import br.unitins.facelocus.dto.LocationDTO;
import br.unitins.facelocus.dto.PointDTO;
import br.unitins.facelocus.dto.eventrequest.EventWithoutRelationshipsDTO;
import br.unitins.facelocus.model.Factor;
import br.unitins.facelocus.model.UserAttendance;

import java.time.LocalDate;
import java.util.List;
import java.util.Set;

public record PointRecordResponseDTO(Long id,
                                     EventWithoutRelationshipsDTO event,
                                     LocalDate date,
                                     LocationDTO location,
                                     List<PointDTO> points,
                                     Set<Factor> factors,
                                     Double allowableRadiusInMeters,
                                     boolean inProgress,
                                     List<UserAttendanceResponseDTO> usersAttendances
) {
}
