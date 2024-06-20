package br.unitins.facelocus.dto.eventrequest;

import br.unitins.facelocus.dto.event.LocationDTO;
import br.unitins.facelocus.dto.event.PointDTO;
import br.unitins.facelocus.dto.pointrecord.UserAttendanceResponseDTO;
import br.unitins.facelocus.model.Factor;

import java.time.LocalDate;
import java.util.List;
import java.util.Set;

public record PointRecordResponseExportDTO(Long id,
                                           LocalDate date,
                                           LocationDTO location,
                                           List<PointDTO> points,
                                           Set<Factor> factors,
                                           Double allowableRadiusInMeters,
                                           List<UserAttendanceResponseExportDTO> usersAttendances) {
}

