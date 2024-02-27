package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.UserAttendance;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.Optional;

@ApplicationScoped
public class UserAttendanceRepository extends BaseRepository<UserAttendance> {

    public UserAttendanceRepository() {
        super(UserAttendance.class);
    }

    public Optional<UserAttendance> findByPointRecordAndUser(Long pointRecordId, Long userId) {
        // language=jpaql
        String query = """
                FROM UserAttendance ua
                    JOIN ua.pointRecord pr
                    JOIN ua.user u
                WHERE pr.id = ?1 AND u.id = ?2
                """;
        return find(query, pointRecordId, userId).singleResultOptional();
    }
}
