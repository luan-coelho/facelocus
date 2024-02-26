package br.unitins.facelocus.dto.pointrecord;

import br.unitins.facelocus.dto.event.PointDTO;
import br.unitins.facelocus.model.AttendanceRecordStatus;

public record AttendanceRecordResponseDTO(
                Long id,
                // List<ValidationAttempt> validationAttempts,
                AttendanceRecordStatus status,
                PointDTO point) {
}