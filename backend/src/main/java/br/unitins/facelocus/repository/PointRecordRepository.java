package br.unitins.facelocus.repository;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.model.PointRecord;
import io.quarkus.hibernate.orm.panache.PanacheQuery;
import jakarta.enterprise.context.ApplicationScoped;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

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

    public List<PointRecord> findAllByUser(Long userId) {
        // language=jpaql
        String query = """
                SELECT DISTINCT pr
                FROM PointRecord pr
                    JOIN pr.event e
                    JOIN pr.points
                    JOIN pr.usersAttendances ua
                    LEFT JOIN e.users lu
                WHERE lu.id = ?1
                """;
        return find(query, userId).list();
    }

    @Override
    public Optional<PointRecord> findByIdOptional(Long pointRecordId) {
        // language=jpaql
        String query = """
                FROM PointRecord pr
                    JOIN pr.event e
                    LEFT JOIN FETCH e.locations
                    JOIN pr.points
                    LEFT JOIN pr.usersAttendances
                WHERE pr.id = ?1
                """;
        return find(query, pointRecordId).singleResultOptional();
    }
}
