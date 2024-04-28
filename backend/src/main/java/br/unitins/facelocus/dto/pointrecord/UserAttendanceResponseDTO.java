package br.unitins.facelocus.dto.pointrecord;

import br.unitins.facelocus.dto.event.LocationDTO;
import br.unitins.facelocus.dto.user.UserResponseDTO;

import java.time.LocalDate;
import java.util.List;

public record UserAttendanceResponseDTO(
        Long id,
        UserResponseDTO user,
        List<AttendanceRecordResponseDTO> attendanceRecords,
        PointRecordResponseDTO pointRecord,
        boolean validatedFaceRecognition,
        boolean validatedLocation
) {
    public record PointRecordResponseDTO(Long id,
                                         LocalDate date,
                                         LocationDTO location,
                                         Double allowableRadiusInMeters,
                                         boolean inProgress) {
    }
}