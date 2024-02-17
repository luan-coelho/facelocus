package br.unitins.facelocus.repository;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.model.PointRecord;
import io.quarkus.hibernate.orm.panache.PanacheQuery;
import jakarta.enterprise.context.ApplicationScoped;

import java.time.LocalDate;
import java.util.List;

@ApplicationScoped
public class PointRecordRepository extends BaseRepository<PointRecord> {

    public PointRecordRepository() {
        super(PointRecord.class);
    }

    public DataPagination<PointRecord> findAllByUser(Pageable pageable, Long userId) {
        // language=jpaql
        String query = """
                SELECT DISTINCT pr
                FROM PointRecord pr
                    JOIN pr.event e
                    JOIN e.administrator u
                    JOIN pr.points
                    JOIN pr.usersAttendances ua
                    LEFT JOIN e.users lu
                WHERE u.id = ?1 OR lu.id = ?1
                """;
        PanacheQuery<PointRecord> panacheQuery = find(query, userId);
        return buildDataPagination(pageable, panacheQuery);
    }

    public List<PointRecord> findAllByDate(Long userId, LocalDate date) {
        // language=jpaql
        var query = """
                SELECT DISTINCT pr
                FROM PointRecord pr
                    JOIN FETCH pr.event e
                    JOIN FETCH e.administrator u
                    LEFT JOIN e.users lu
                WHERE pr.date = ?1 AND (u.id = ?2 OR lu.id = ?2)""";
        return find(query, date, userId).list();
    }
}
