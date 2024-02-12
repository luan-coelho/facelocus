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
import jakarta.ws.rs.NotFoundException;

import java.time.LocalDate;
import java.time.LocalDateTime;
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
    public DataPagination<PointRecordResponseDTO> findAllByUser(Pageable pageable, Long userId) {
        DataPagination<PointRecord> dataPagination = this.repository.findAllByUser(pageable, userId);
        return pointRecordMapper.toResource(dataPagination);
    }

    public List<PointRecord> findAllByDate(Long userId, LocalDate date) {
        return this.repository.findAllByDate(userId, date);
    }

    @Transactional
    @Override
    public PointRecord create(PointRecord pointRecord) {
        PointRecord pr = super.create(pointRecord);

        if (pointRecord.getDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("A data deve ser igual ou posterior ao dia de hoje");
        }

        if (pointRecord.getPoints() == null || pointRecord.getPoints().isEmpty()) {
            throw new IllegalArgumentException("É necessário informar pelo menos um intervalo de ponto");
        }

        LocalDateTime lastDatetime = null;
        for (Point point : pointRecord.getPoints()) {
            LocalDateTime initialDateStartOfMinute = point.getInitialDate().withSecond(0).withNano(0);
            LocalDateTime finalDateStartOfMinute = point.getFinalDate().withSecond(0).withNano(0);

            if (!initialDateStartOfMinute.isBefore(finalDateStartOfMinute)) {
                throw new IllegalArgumentException("A data inicial de um ponto deve ser superior a final");
            }

            if (lastDatetime != null && !initialDateStartOfMinute.isAfter(lastDatetime)) {
                throw new IllegalArgumentException("Cada intervalo de ponto deve ser superior ao inferior");
            }
            point.setPointRecord(pr);
            lastDatetime = point.getFinalDate().withSecond(0).withNano(0);
        }
        pointService.persistAll(pr.getPoints());
        return pr;
    }

    public void validatePoint(Long pointId) {
        Point point = pointService.findByIdOptional(pointId)
                .orElseThrow(() -> new IllegalArgumentException("Ponto não encontrado pelo id"));

    }

    @Transactional
    public PointRecord toggleActivity(Long pointRecordId) {
        PointRecord pointRecord = findByIdOptional(pointRecordId)
                .orElseThrow(() -> new NotFoundException("Registro de ponto não encontrado pelo id"));
        pointRecord.setInProgress(!pointRecord.isInProgress());
        return update(pointRecord);
    }
}
