package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.eventrequest.PointRecordResponseDTO;
import br.unitins.facelocus.mapper.PointRecordMapper;
import br.unitins.facelocus.model.*;
import br.unitins.facelocus.repository.PointRecordRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@ApplicationScoped
public class PointRecordService extends BaseService<PointRecord, PointRecordRepository> {

    @Inject
    PointRecordMapper pointRecordMapper;

    @Inject
    LocationService locationService;

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
        if (pointRecord.getEvent() == null || pointRecord.getEvent().getId() == null) {
            throw new IllegalArgumentException("Informe o evento");
        }

        if (pointRecord.getDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("A data deve ser igual ou posterior ao dia de hoje");
        }

        if (pointRecord.getPoints() == null || pointRecord.getPoints().isEmpty()) {
            throw new IllegalArgumentException("É necessário informar pelo menos um intervalo de ponto");
        }

        validatePoints(pointRecord);
        createUsersAttendances(pointRecord);
        validateFactors(pointRecord);

        return super.create(pointRecord);
    }

    private void validateFactors(PointRecord pointRecord) {
        Set<Factor> factors = pointRecord.getFactors();

        if (factors == null || factors.isEmpty()) {
            return;
        }

        if (factors.contains(Factor.INDOOR_LOCATION)) {
            if (pointRecord.getAllowableRadiusInMeters() == null || pointRecord.getAllowableRadiusInMeters() == 0) {
                throw new IllegalArgumentException("Informe o raio permitido em metros");
            }

            if (pointRecord.getLocation() == null || pointRecord.getLocation().getId() == null) {
                throw new IllegalArgumentException("Informe a localização");
            }
            Location location = locationService.findByIdOptional(pointRecord.getLocation().getId())
                    .orElseThrow(() -> new NotFoundException("Registro de ponto não encontrado pelo id"));
            pointRecord.setLocation(location);
        } else {
            pointRecord.setAllowableRadiusInMeters(null);
        }
    }

    private void validatePoints(PointRecord pointRecord) {
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
            point.setPointRecord(pointRecord);
            lastDatetime = point.getFinalDate().withSecond(0).withNano(0);
        }
    }

    /**
     * Cria registros de presença para cada usuário cadastrado no evento, conforme o número de pontos.
     *
     * @param pointRecord Registro de Ponto
     */
    private void createUsersAttendances(PointRecord pointRecord) {
        List<UserAttendance> usersAttendances = new ArrayList<>();
        for (User user : pointRecord.getEvent().getUsers()) {
            List<AttendanceRecord> attendanceRecords = new ArrayList<>();
            for (Point point : pointRecord.getPoints()) {
                AttendanceRecord attendanceRecord = new AttendanceRecord(
                        null,
                        null,
                        AttendanceRecordStatus.PENDING,
                        point
                );
                attendanceRecords.add(attendanceRecord);
            }
            UserAttendance userAttendance = new UserAttendance(
                    null,
                    user,
                    attendanceRecords,
                    pointRecord
            );
            usersAttendances.add(userAttendance);
        }
        pointRecord.setUsersAttendances(usersAttendances);
    }

    @Transactional
    public void toggleActivity(Long pointRecordId) {
        PointRecord pointRecord = findByIdOptional(pointRecordId)
                .orElseThrow(() -> new NotFoundException("Registro de ponto não encontrado pelo id"));
        pointRecord.setInProgress(!pointRecord.isInProgress());
        update(pointRecord);
    }

    @Transactional
    public void addFactor(Long pointRecordId, Factor factor) {
        PointRecord pointRecord = findByIdOptional(pointRecordId)
                .orElseThrow(() -> new NotFoundException("Registro de ponto não encontrado pelo id"));
        pointRecord.getFactors().add(factor);
        update(pointRecord);
    }

    @Transactional
    public void removeFactor(Long pointRecordId, Factor factor) {
        PointRecord pointRecord = findByIdOptional(pointRecordId)
                .orElseThrow(() -> new NotFoundException("Registro de ponto não encontrado pelo id"));
        pointRecord.getFactors().remove(factor);
        update(pointRecord);
    }
}
