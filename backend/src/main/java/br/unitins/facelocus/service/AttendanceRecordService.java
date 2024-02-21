package br.unitins.facelocus.service;

import br.unitins.facelocus.model.AttendanceRecord;
import br.unitins.facelocus.repository.AttendanceRecordRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class AttendanceRecordService extends BaseService<AttendanceRecord, AttendanceRecordRepository> {

    public AttendanceRecord findByUserAndPoint(Long userId, Long pointId) {
        return this.repository.findByUserAndPoint(userId, pointId)
                .orElseThrow(() -> new IllegalArgumentException("AttendanceRecord não encontrado pelo id"));
    }
}
