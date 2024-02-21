package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.AttendanceRecord;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.Optional;

@ApplicationScoped
public class AttendanceRecordRepository extends BaseRepository<AttendanceRecord> {

    public AttendanceRecordRepository() {
        super(AttendanceRecord.class);
    }

    public Optional<AttendanceRecord> findByUserAndPoint(Long userId, Long pointId) {
        // language=jpaql
        String query = """
                FROM AttendanceRecord ar
                WHERE ar.point.id = ?2
                AND ar.userAttendance.user = ?1
                """;
        return find(query, userId, pointId).singleResultOptional();
    }
}
