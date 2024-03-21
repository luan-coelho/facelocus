package br.unitins.facelocus.service;

import br.unitins.facelocus.model.AttendanceRecord;
import br.unitins.facelocus.model.AttendanceRecordStatus;
import br.unitins.facelocus.model.Point;
import br.unitins.facelocus.model.UserAttendance;
import br.unitins.facelocus.repository.UserAttendanceRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@ApplicationScoped
public class UserAttendanceService extends BaseService<UserAttendance, UserAttendanceRepository> {

    public List<UserAttendance> findAllByPointRecord(Long pointRecordId) {
        return this.repository.findAllByPointRecord(pointRecordId);
    }

    @Transactional
    public UserAttendance findByPointRecordAndUser(Long pointRecordId, Long userId) {
        UserAttendance userAttendance = this.repository
                .findByPointRecordAndUser(pointRecordId, userId)
                .orElseThrow(() -> new IllegalArgumentException("Presença de usuário não encontrada por id"));

        LocalDateTime now = LocalDateTime.now();
        boolean modificationOccurred = false;

        for (AttendanceRecord ar : userAttendance.getAttendanceRecords()) {
            Point point = ar.getPoint();
            LocalDateTime finalDate = point.getFinalDate();
            AttendanceRecordStatus status = ar.getStatus();

            if (status.equals(AttendanceRecordStatus.PENDING) && finalDate.isBefore(now)) {
                ar.setStatus(AttendanceRecordStatus.NOT_VALIDATED);
                modificationOccurred = true;
            }
        }

        if (modificationOccurred) {
            this.repository.persist(userAttendance);
        }

        return userAttendance;
    }
}
