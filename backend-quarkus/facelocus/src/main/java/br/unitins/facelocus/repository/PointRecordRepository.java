package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.PointRecord;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class PointRecordRepository extends BaseRepository<PointRecord> {

    public PointRecordRepository() {
        super(PointRecord.class);
    }

    public List<PointRecord> findAllByUser(Long userId) {
        return find("FROM PointRecord pr JOIN FETCH pr.event e JOIN FETCH e.users u WHERE u.id = ?1", userId).list();
    }
}
