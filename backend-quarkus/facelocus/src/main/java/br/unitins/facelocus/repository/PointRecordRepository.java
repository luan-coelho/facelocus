package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.PointRecord;
import jakarta.enterprise.context.ApplicationScoped;

import java.time.LocalDate;
import java.util.List;

@ApplicationScoped
public class PointRecordRepository extends BaseRepository<PointRecord> {

    public PointRecordRepository() {
        super(PointRecord.class);
    }

    public List<PointRecord> findAllByUser(Long userId) {
        // language=jpaql
        String query = """
                FROM PointRecord pr
                    JOIN FETCH pr.event e
                    JOIN FETCH e.users lu
                    JOIN FETCH e.administrator u
                WHERE u.id = ?1 OR lu.id = ?1
                """;
        return find(query, userId).list();
    }

    public List<PointRecord> findAllByDate(Long userId, LocalDate date) {
        // language=jpaql
        var query = """
                FROM PointRecord pr
                    JOIN FETCH pr.event e
                    JOIN FETCH e.users lu
                    JOIN FETCH e.administrator u
                WHERE pr.date = ?1 AND (u.id = ?2 OR lu.id = ?2)""";
        return find(query, date, userId).list();
    }
}
