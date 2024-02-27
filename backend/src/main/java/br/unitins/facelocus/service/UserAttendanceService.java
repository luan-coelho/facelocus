package br.unitins.facelocus.service;

import br.unitins.facelocus.model.UserAttendance;
import br.unitins.facelocus.repository.UserAttendanceRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class UserAttendanceService extends BaseService<UserAttendance, UserAttendanceRepository> {

    public UserAttendance findByPointRecordAndUser(Long pointRecordId, Long userId) {
        return this.repository.findByPointRecordAndUser(pointRecordId, userId)
                .orElseThrow(() -> new IllegalArgumentException("Presença de usuário não encontrada por id"));
    }
}
