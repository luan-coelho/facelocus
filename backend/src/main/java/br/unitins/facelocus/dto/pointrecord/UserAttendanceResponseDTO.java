package br.unitins.facelocus.dto.pointrecord;

import br.unitins.facelocus.dto.user.UserResponseDTO;

import java.util.List;

public record UserAttendanceResponseDTO(
        Long id,
        UserResponseDTO user,
        List<AttendanceRecordResponseDTO> attendanceRecords
) {
}