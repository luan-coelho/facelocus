package br.unitins.facelocus.service;

import br.unitins.facelocus.model.AttendanceRecord;
import br.unitins.facelocus.repository.AttendanceRecordRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class AttendanceRecordService extends BaseService<AttendanceRecord, AttendanceRecordRepository> {
}
