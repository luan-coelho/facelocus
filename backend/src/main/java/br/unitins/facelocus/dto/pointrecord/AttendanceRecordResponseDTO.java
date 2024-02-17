package br.unitins.facelocus.dto.pointrecord;

import br.unitins.facelocus.dto.PointDTO;
import br.unitins.facelocus.model.AttendanceRecordStatus;
import br.unitins.facelocus.model.ValidationAttempt;

import java.util.List;

public record AttendanceRecordResponseDTO(
        Long id,
//        List<ValidationAttempt> validationAttempts,
        AttendanceRecordStatus status,
        PointDTO point
) {}