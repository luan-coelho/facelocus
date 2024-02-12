package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.commons.pagination.Pagination;
import br.unitins.facelocus.dto.eventrequest.PointRecordResponseDTO;
import br.unitins.facelocus.model.Factor;
import br.unitins.facelocus.model.Point;
import br.unitins.facelocus.model.PointRecord;
import io.quarkus.test.TestTransaction;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.containsInAnyOrder;
import static org.junit.jupiter.api.Assertions.*;

@QuarkusTest
class PointRecordServiceTest extends BaseTest {

    @Inject
    PointRecordService pointRecordService;

    @BeforeEach
    public void setup() {
        user1 = getUser();
        event1 = getEvent();
        event2 = getEvent();
        today = LocalDate.now();
        now = LocalDateTime.now();
    }

    @Test
    @TestTransaction
    @DisplayName("Deve criar um registro de ponto com sucesso quandos os dados forem válidos")
    void mustCreatePointRecordSuccessfullyWhenDataAreValid() {
        PointRecord pointRecord = getPointRecord();
        pointRecordService.create(pointRecord);

        assertNotNull(pointRecord.getId());
        assertNotNull(pointRecord.getEvent().getId());
        assertTrue(pointRecord.getDate().isEqual(today));
        assertEquals(2, pointRecord.getFactors().size());
        assertFalse(pointRecord.getPoints().isEmpty());
        assertFalse(pointRecord.isInProgress());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando a data for anterior ao dia de hoje")
    void throwExceptionIfDateIsBeforeToday() {
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event1);
        pointRecord.setDate(today.minusDays(1));

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> pointRecordService.create(pointRecord)
        );

        assertEquals("A data deve ser igual ou posterior ao dia de hoje", exception.getMessage());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando não for informado nenhum ponto")
    void throwExceptionIfNoPointsProvided() {
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event1);
        pointRecord.setDate(today);
        pointRecord.setFactors(Set.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
        pointRecord.setInProgress(false);

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> pointRecordService.create(pointRecord)
        );

        assertEquals("É necessário informar pelo menos um intervalo de ponto", exception.getMessage());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando for informado um ponto com data inicial inferior a final")
    void throwExceptionIfStartDateIsGreaterThanEndDate() {
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event1);
        pointRecord.setDate(today);
        pointRecord.setFactors(Set.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
        pointRecord.setInProgress(false);
        Point point = new Point(
                null,
                now,
                now.minusMinutes(15),
                false,
                pointRecord);
        pointRecord.setPoints(List.of(point));

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> pointRecordService.create(pointRecord)
        );

        assertEquals("A data inicial de um ponto deve ser superior a final", exception.getMessage());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando for informado um ponto com data inicial igual a final")
    void throwExceptionIfStartDateEqualsEndDate() {
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event1);
        pointRecord.setDate(today);
        pointRecord.setFactors(Set.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
        pointRecord.setInProgress(false);
        Point point = new Point(
                null,
                now,
                now,
                false,
                pointRecord);
        pointRecord.setPoints(List.of(point));

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> pointRecordService.create(pointRecord)
        );

        assertEquals("A data inicial de um ponto deve ser superior a final", exception.getMessage());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando for informado um ponto com intervalo inferior ao anterior")
    void throwExceptionIfIntervalIsLessThanPrevious() {
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event1);
        pointRecord.setDate(today);
        pointRecord.setFactors(Set.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
        pointRecord.setInProgress(false);
        Point point1 = new Point(
                null,
                now,
                now.plusMinutes(15),
                false,
                pointRecord);
        Point point2 = new Point(
                null,
                now.minusMinutes(30),
                now.minusMinutes(15),
                false,
                pointRecord);
        pointRecord.setPoints(List.of(point1, point2));

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> pointRecordService.create(pointRecord)
        );

        assertEquals("Cada intervalo de ponto deve ser superior ao inferior", exception.getMessage());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando for informado um fator de localização indoor sem raio permitido")
    void throwExceptionIfIndoorLocationFactorWithoutAllowedRadius() {
        PointRecord pointRecord = getPointRecord();
        pointRecordService.create(pointRecord);
        pointRecord.setAllowableRadiusInMeters(null);

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> pointRecordService.create(pointRecord)
        );

        assertEquals("Informe o raio permitido em metros", exception.getMessage());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando for informado um fator de localização indoor com raio permitido zero")
    void throwExceptionIfIndoorLocationFactorWithZeroAllowedRadius() {
        PointRecord pointRecord = getPointRecord();
        pointRecordService.create(pointRecord);
        pointRecord.setAllowableRadiusInMeters(0d);

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> pointRecordService.create(pointRecord)
        );

        assertEquals("Informe o raio permitido em metros", exception.getMessage());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve retornar todos os registros de ponto vinculados a um usuário")
    void shouldReturnAllPointRecordsLinkedToAUser() {
        PointRecord pointRecord1 = getPointRecord();
        event1.setAdministrator(user1);
        pointRecord1.setEvent(event1);
        PointRecord pointRecord2 = getPointRecord();
        event2.getUsers().add(user1);
        pointRecord2.setEvent(event2);

        pointRecordService.create(pointRecord1);
        pointRecordService.create(pointRecord2);

        Pageable pageable = new Pageable();
        DataPagination<PointRecordResponseDTO> dataPagination = pointRecordService.findAllByUser(pageable, user1.getId());
        Pagination pagination = dataPagination.getPagination();
        List<PointRecordResponseDTO> data = dataPagination.getData();

        assertEquals(2, data.size());
        assertEquals(2, pagination.getTotalItems());
        assertEquals(0, pagination.getCurrentPage());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve iniciar ou parar um registro de ponto")
    void startOrStopPointRecord() {
        PointRecord pointRecord = getPointRecord();
        boolean inProgress = false;
        pointRecord.setInProgress(inProgress);
        em.merge(pointRecord);

        pointRecordService.toggleActivity(pointRecord.getId());
        pointRecord = pointRecordService.findById(pointRecord.getId());

        assertEquals(!inProgress, pointRecord.isInProgress());
    }


    @Test
    @TestTransaction
    @DisplayName("Deve adicionar um fator a um registro de ponto que não possui fatores")
    void enableOrDisablePointRecordFactor() {
        PointRecord pointRecord = getPointRecord();
        pointRecord.setFactors(Set.of());
        em.merge(pointRecord);

        pointRecordService.addFactor(pointRecord.getId(), Factor.FACIAL_RECOGNITION);
        pointRecord = pointRecordService.findById(pointRecord.getId());
        Set<Factor> actualFactorSet = pointRecord.getFactors();

        assertIterableEquals(Set.of(Factor.FACIAL_RECOGNITION), actualFactorSet);
    }

    @Test
    @TestTransaction
    @DisplayName("Deve adicionar um fator a um registro de ponto que já possui o fator informado")
    void addFactorToPointRecordWithExistingFactors() {
        PointRecord pointRecord = getPointRecord();
        pointRecord.setFactors(Set.of(Factor.FACIAL_RECOGNITION));
        em.merge(pointRecord);

        pointRecordService.addFactor(pointRecord.getId(), Factor.FACIAL_RECOGNITION);
        pointRecord = pointRecordService.findById(pointRecord.getId());
        Set<Factor> actualFactorSet = pointRecord.getFactors();

        assertIterableEquals(Set.of(Factor.FACIAL_RECOGNITION), actualFactorSet);
    }

    @Test
    @TestTransaction
    @DisplayName("Deve adicionar outro fator a um registro de ponto que já possui um fator")
    void addFactorToPointRecordWithExistingFactor() {
        PointRecord pointRecord = getPointRecord();
        pointRecord.setFactors(Set.of(Factor.INDOOR_LOCATION));
        em.merge(pointRecord);

        pointRecordService.addFactor(pointRecord.getId(), Factor.FACIAL_RECOGNITION);
        pointRecord = pointRecordService.findById(pointRecord.getId());
        Set<Factor> actualFactorSet = pointRecord.getFactors();

        assertThat(actualFactorSet, containsInAnyOrder(Factor.INDOOR_LOCATION, Factor.FACIAL_RECOGNITION));
    }

    @Test
    @TestTransaction
    @DisplayName("Deve remover um fator de um registro de ponto")
    void removeFactorFromPointRecord() {
        PointRecord pointRecord = getPointRecord();
        pointRecord.setFactors(Set.of(Factor.FACIAL_RECOGNITION));
        em.merge(pointRecord);

        pointRecordService.removeFactor(pointRecord.getId(), Factor.FACIAL_RECOGNITION);
        pointRecord = pointRecordService.findById(pointRecord.getId());
        Set<Factor> actualFactorSet = pointRecord.getFactors();

        assertIterableEquals(Set.of(), actualFactorSet);
    }

    @Test
    @TestTransaction
    @DisplayName("Deve remover um fator de um registro de ponto que já possui outro fator")
    void removeFactorFromTimeRecordWithExistingFactor() {
        PointRecord pointRecord = getPointRecord();
        pointRecord.setFactors(Set.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
        em.merge(pointRecord);

        pointRecordService.removeFactor(pointRecord.getId(), Factor.FACIAL_RECOGNITION);
        pointRecord = pointRecordService.findById(pointRecord.getId());
        Set<Factor> actualFactorSet = pointRecord.getFactors();

        assertEquals(Set.of(Factor.INDOOR_LOCATION), actualFactorSet);
    }

    @Test
    @TestTransaction
    @DisplayName("Não deve fazer nada ao remover um fator de um registro de ponto que não possui fatores")
    void doNothingWhenRemovingFactorFromPointRecordWithoutFactors() {
        PointRecord pointRecord = getPointRecord();
        pointRecord.setFactors(Set.of());
        em.merge(pointRecord);

        pointRecordService.removeFactor(pointRecord.getId(), Factor.FACIAL_RECOGNITION);
        pointRecord = pointRecordService.findById(pointRecord.getId());
        Set<Factor> actualFactorSet = pointRecord.getFactors();

        assertIterableEquals(Set.of(), actualFactorSet);
    }
}