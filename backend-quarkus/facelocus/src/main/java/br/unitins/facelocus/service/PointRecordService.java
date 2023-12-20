package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.PointRecordDTO;
import br.unitins.facelocus.mapper.PointRecordMapper;
import br.unitins.facelocus.model.PointRecord;
import br.unitins.facelocus.repository.PointRecordRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;

import java.util.List;

@ApplicationScoped
public class PointRecordService extends BaseService<PointRecord, PointRecordRepository> {

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
        List<PointRecordDTO> dtos = this.repository.findAllByUser(userId)
                .stream()
                .map(t -> pointRecordMapper.toResource(t))
                .toList();
        return buildPagination(dtos, pageable);
    }

    @Transactional
    @Override
    public PointRecord create(PointRecord pointRecord) {
        pointRecord.getPoints().forEach(point -> point.setPointRecord(pointRecord));
        return super.create(pointRecord);
    }
}
