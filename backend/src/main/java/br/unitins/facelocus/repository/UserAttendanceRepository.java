package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.UserAttendance;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class UserAttendanceRepository extends BaseRepository<UserAttendance> {

    public UserAttendanceRepository() {
        super(UserAttendance.class);
    }

    public List<UserAttendance> findAllByPointRecord(Long pointRecordId) {
        // language=jpaql
        String query = """
                FROM UserAttendance ua
                    JOIN ua.pointRecord pr
                WHERE pr.id = ?1
                """;
        return find(query, pointRecordId).list();
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

    public List<UserAttendance> findAllByUser(Long userId) {
        // language=jpaql
        String query = """
                FROM UserAttendance ua
                    JOIN ua.user u
                WHERE u.id = ?1
                """;
        return find(query, userId).list();
    }
}
