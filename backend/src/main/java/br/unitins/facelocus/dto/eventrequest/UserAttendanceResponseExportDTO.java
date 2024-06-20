package br.unitins.facelocus.dto.eventrequest;

import br.unitins.facelocus.dto.event.LocationDTO;
import br.unitins.facelocus.dto.pointrecord.AttendanceRecordResponseDTO;
import br.unitins.facelocus.dto.user.UserResponseDTO;

import java.time.LocalDate;
import java.util.List;

public record UserAttendanceResponseExportDTO(
        Long id,
        UserResponseExportDTO user,
        List<AttendanceRecordResponseDTO> attendanceRecords,
        boolean validatedFaceRecognition,
        boolean validatedLocation
) {
}
