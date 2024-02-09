package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.eventrequest.PointRecordResponseDTO;
import br.unitins.facelocus.mapper.PointRecordMapper;
import br.unitins.facelocus.model.Point;
import br.unitins.facelocus.model.PointRecord;
import br.unitins.facelocus.repository.PointRecordRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;

import java.time.LocalDate;
import java.util.List;

@ApplicationScoped
public class PointRecordService extends BaseService<PointRecord, PointRecordRepository> {

    @Inject
    PointService pointService;

    @Inject
    PointRecordMapper pointRecordMapper;

    /**
     * Responsável por buscar todos os registros de ponto vinculados a um usuário
     *
     * @param pageable Informações de paginação
     * @param userId   Identificador do usuário
     * @return Objeto paginável de registros de ponto
     */
    public DataPagination<?> findAllByUser(Pageable pageable, Long userId) {
        List<PointRecordResponseDTO> dtos = this.repository.findAllByUser(userId)
                .stream()
                .map(t -> pointRecordMapper.toResource(t))
                .toList();
        return buildPagination(dtos, pageable);
    }

    public List<PointRecord> findAllByDate(Long userId, LocalDate date) {
        return this.repository.findAllByDate(userId, date);
    }

    @Transactional
    @Override
    public PointRecord create(PointRecord pointRecord) {
        PointRecord pr = super.create(pointRecord);
        if (pointRecord.getPoints() == null || pointRecord.getPoints().isEmpty()) {
            throw new IllegalArgumentException("É necessário informar pelo menos um intervalo de ponto");
        }

        for (Point point : pointRecord.getPoints()) {
            point.setPointRecord(pr);
        }
        pointService.persistAll(pr.getPoints());
        return pr;
    }
}
