package br.unitins.facelocus.service;

import br.unitins.facelocus.model.UserAttendance;
import br.unitins.facelocus.repository.UserAttendanceRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class UserAttendanceService extends BaseService<UserAttendance, UserAttendanceRepository> {
}
