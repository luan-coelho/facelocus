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
        return find("FROM PointRecord pr JOIN FETCH pr.event e JOIN FETCH e.administrator u WHERE u.id = ?1", userId).list();
    }

    public List<PointRecord> findAllByDate(Long userId, LocalDate date) {
        var query = "FROM PointRecord pr JOIN FETCH pr.event e JOIN FETCH e.administrator u WHERE pr.date = ?1 AND u.id = ?2";
        return find(query, date, userId).list();
    }
}
