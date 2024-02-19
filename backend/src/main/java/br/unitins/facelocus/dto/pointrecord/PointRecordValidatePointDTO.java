package br.unitins.facelocus.dto.pointrecord;

import br.unitins.facelocus.model.AttendanceRecord;

import java.util.List;

public record PointRecordValidatePointDTO(List<AttendanceRecord> attendancesRecord) {
}
