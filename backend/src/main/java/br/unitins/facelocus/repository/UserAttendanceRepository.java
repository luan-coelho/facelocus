package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.UserAttendance;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class UserAttendanceRepository extends BaseRepository<UserAttendance> {

    public UserAttendanceRepository() {
        super(UserAttendance.class);
    }
}
