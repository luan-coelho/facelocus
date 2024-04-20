package br.unitins.facelocus.dto.pointrecord;

import br.unitins.facelocus.dto.event.LocationDTO;
import br.unitins.facelocus.dto.event.PointDTO;
import br.unitins.facelocus.dto.eventrequest.EventWithoutRelationshipsDTO;
import br.unitins.facelocus.dto.user.UserResponseDTO;
import br.unitins.facelocus.model.Factor;
import br.unitins.facelocus.model.PointRecord;

import java.time.LocalDate;
import java.util.List;
import java.util.Set;

public record UserAttendanceResponseDTO(
        Long id,
        UserResponseDTO user,
        List<AttendanceRecordResponseDTO> attendanceRecords,
        PointRecordResponseDTO pointRecord
) {
    public record PointRecordResponseDTO(Long id,
                                         LocalDate date,
                                         LocationDTO location,
                                         Double allowableRadiusInMeters,
                                         boolean inProgress) {
    }
}