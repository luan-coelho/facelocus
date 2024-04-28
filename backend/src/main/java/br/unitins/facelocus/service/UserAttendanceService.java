package br.unitins.facelocus.service;

import br.unitins.facelocus.model.*;
import br.unitins.facelocus.repository.UserAttendanceRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@ApplicationScoped
public class UserAttendanceService extends BaseService<UserAttendance, UserAttendanceRepository> {

    @Transactional
    public List<UserAttendance> findAllByUser(Long userId) {
        List<UserAttendance> uas = this.repository.findAllByUser(userId);
        uas.forEach(this::verifyStatus);
        uas.forEach(this::checkWhetherFactorsHaveBeenValidated);
        return uas;
    }

    @Override
    public UserAttendance findById(Long id) {
        UserAttendance ua = super.findById(id);
        verifyStatus(ua);
        checkWhetherFactorsHaveBeenValidated(ua);
        return ua;
    }

    @Transactional
    public List<UserAttendance> findAllByPointRecord(Long pointRecordId) {
        List<UserAttendance> uas = this.repository.findAllByPointRecord(pointRecordId);
        uas.forEach(this::verifyStatus);
        uas.forEach(this::checkWhetherFactorsHaveBeenValidated);
        return uas;
    }

    @Transactional
    public UserAttendance findByPointRecordAndUser(Long pointRecordId, Long userId) {
        UserAttendance ua = this.repository
                .findByPointRecordAndUser(pointRecordId, userId)
                .orElseThrow(() -> new IllegalArgumentException("Presença de usuário não encontrada por id"));
        verifyStatus(ua);
        checkWhetherFactorsHaveBeenValidated(ua);
        return ua;
    }

    private void verifyStatus(UserAttendance userAttendance) {
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
    }

    private void checkWhetherFactorsHaveBeenValidated(UserAttendance userAttendance) {
        List<AttendanceRecord> attendanceRecords = userAttendance.getAttendanceRecords();
        for (AttendanceRecord attendanceRecord : attendanceRecords) {
            List<LocationValidationAttempt> locationAttempts = attendanceRecord.getLocationValidationAttempts();
            List<FaceRecognitionValidationAttempt> frAttempts = attendanceRecord.getFrValidationAttempts();

            locationAttempts.forEach(locationAttempt -> {
                if (locationAttempt.isValidated()) {
                    attendanceRecord.setLocationValidatedSuccessfully(true);
                }
            });

            frAttempts.forEach(frAttempt -> {
                if (frAttempt.isValidated()) {
                    attendanceRecord.setFrValidatedSuccessfully(true);
                }
            });
        }
    }
}
