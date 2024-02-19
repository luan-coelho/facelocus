package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.AttendanceRecord;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class AttendanceRecordRepository extends BaseRepository<AttendanceRecord> {

    public AttendanceRecordRepository() {
        super(AttendanceRecord.class);
    }
}
