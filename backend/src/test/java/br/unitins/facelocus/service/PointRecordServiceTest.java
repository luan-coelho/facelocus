package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.commons.pagination.Pagination;
import br.unitins.facelocus.dto.pointrecord.PointRecordResponseDTO;
import br.unitins.facelocus.model.Factor;
import br.unitins.facelocus.model.Point;
import br.unitins.facelocus.model.PointRecord;
import br.unitins.facelocus.model.User;
import io.quarkus.test.TestTransaction;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.containsInAnyOrder;
import static org.junit.jupiter.api.Assertions.*;

@QuarkusTest
class PointRecordServiceTest extends BaseTest {

    User user3;
    User user4;
    User user5;

    @Inject
    PointRecordService pointRecordService;

    @BeforeEach
    public void setup() {
        user1 = getUser();
        user2 = getUser();
        user3 = getUser();
        user4 = getUser();
        user5 = getUser();
        location = getLocation();
        event1 = getEvent();
        event2 = getEvent();
        today = LocalDate.now();
        now = LocalDateTime.now();
    }

    @Test
    @TestTransaction
    @DisplayName("Deve criar um registro de ponto com sucesso quandos os dados forem válidos")
    void shouldCreatePointRecordSuccessfullyWhenDataIsValid() {
        PointRecord pointRecord = getPointRecord();
        pointRecordService.create(pointRecord);
        pointRecord = pointRecordService.findById(pointRecord.getId());

        assertNotNull(pointRecord.getId());
        assertNotNull(pointRecord.getEvent().getId());
        assertEquals(1, pointRecord.getEvent().getUsers().size());
        assertTrue(pointRecord.getDate().isEqual(today));
        assertEquals(3, pointRecord.getPoints().size());
        assertTrue(pointRecord.getUsersAttendances().stream().allMatch(a -> a.getAttendanceRecords().size() == 3));
        assertEquals(2, pointRecord.getFactors().size());
        assertFalse(pointRecord.isInProgress());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando não for informado um evento")
    void shouldThrowWhenEventIsNotProvided() {
        PointRecord pointRecord = new PointRecord();

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> pointRecordService.create(pointRecord)
        );

        assertEquals("Informe o evento", exception.getMessage());
    }

  /*  @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando o registro de ponto estiver ativo e o evento não tiver usuários vinculados")
    void shouldThrowExceptionWhenTimeRecordIsActiveAndEventHasNoLinkedUsers() {
        PointRecord pointRecord = new PointRecord();

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> pointRecordService.create(pointRecord)
        );

        assertEquals("O evento não possui n", exception.getMessage());
    }*/

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando a data for anterior ao dia de hoje")
    void shouldThrowExceptionWhenDateIsBeforeToday() {
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
    void shouldThrowExceptionWhenNoPointRecordIsProvided() {
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
    void shouldThrowExceptionWhenStartDateIsBeforeEndDate() {
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event1);
        pointRecord.setDate(today);
        pointRecord.setFactors(Set.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
        pointRecord.setInProgress(false);
        Point point = new Point(
                null,
                now,
                now.minusMinutes(15),
                pointRecord);
        pointRecord.setPoints(List.of(point));

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> pointRecordService.create(pointRecord)
        );

        assertEquals("A hora inicial de um ponto deve ser antes da final", exception.getMessage());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando for informado um ponto com data inicial igual a final")
    void shouldThrowExceptionWhenStartDateIsEqualToEndDate() {
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event1);
        pointRecord.setDate(today);
        pointRecord.setFactors(Set.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
        pointRecord.setInProgress(false);
        Point point = new Point(
                null,
                now,
                now,
                pointRecord);
        pointRecord.setPoints(List.of(point));

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> pointRecordService.create(pointRecord)
        );

        assertEquals("A hora inicial de um ponto deve ser antes da final", exception.getMessage());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando for informado um ponto com intervalo inferior ao anterior")
    void shouldThrowExceptionWhenIntervalIsShorterThanPrevious() {
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event1);
        pointRecord.setDate(today);
        pointRecord.setFactors(Set.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
        pointRecord.setInProgress(false);
        Point point1 = new Point(
                null,
                now,
                now.plusMinutes(15),
                pointRecord);
        Point point2 = new Point(
                null,
                now.minusMinutes(30),
                now.minusMinutes(15),
                pointRecord);
        pointRecord.setPoints(List.of(point1, point2));

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> pointRecordService.create(pointRecord)
        );

        assertEquals("Cada intervalo de ponto deve ter a hora superior ao anterior", exception.getMessage());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando for informado um fator de localização indoor sem raio permitido")
    void shouldThrowExceptionWhenIndoorLocationFactorIsProvidedWithoutAllowedRadius() {
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
    void shouldThrowExceptionWhenIndoorLocationFactorIsProvidedWithZeroAllowedRadius() {
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
    void shouldStartOrStopAnPointRecord() {
        PointRecord pointRecord = getPointRecord();
        boolean inProgress = false;
        pointRecord.setInProgress(inProgress);
        em.persist(pointRecord);
        pointRecord = pointRecordService.findById(pointRecord.getId());

        pointRecordService.toggleActivity(pointRecord.getId());
        pointRecord = pointRecordService.findById(pointRecord.getId());

        assertEquals(!inProgress, pointRecord.isInProgress());
    }


    @Test
    @TestTransaction
    @DisplayName("Deve adicionar um fator a um registro de ponto que não possui fatores")
    void shouldAddFactorToAnPointRecordWithoutFactors() {
        PointRecord pointRecord = getPointRecord();
        pointRecord.setFactors(new HashSet<>(Set.of()));
        em.persist(pointRecord);
        pointRecord = pointRecordService.findById(pointRecord.getId());

        pointRecordService.addFactor(pointRecord.getId(), Factor.FACIAL_RECOGNITION);
        pointRecord = pointRecordService.findById(pointRecord.getId());
        Set<Factor> actualFactorSet = pointRecord.getFactors();

        assertIterableEquals(Set.of(Factor.FACIAL_RECOGNITION), actualFactorSet);
    }

    @Test
    @TestTransaction
    @DisplayName("Deve adicionar um fator a um registro de ponto que já possui o fator informado")
    void shouldAddFactorToAnPointRecordThatAlreadyHasTheProvidedFactor() {
        PointRecord pointRecord = getPointRecord();
        pointRecord.setFactors(new HashSet<>(Set.of(Factor.FACIAL_RECOGNITION)));
        em.persist(pointRecord);
        pointRecord = pointRecordService.findById(pointRecord.getId());

        pointRecordService.addFactor(pointRecord.getId(), Factor.FACIAL_RECOGNITION);
        pointRecord = pointRecordService.findById(pointRecord.getId());
        Set<Factor> actualFactorSet = pointRecord.getFactors();

        assertIterableEquals(Set.of(Factor.FACIAL_RECOGNITION), actualFactorSet);
    }

    @Test
    @TestTransaction
    @DisplayName("Deve adicionar outro fator a um registro de ponto que já possui um fator")
    void shouldAddAnotherFactorToAnPointRecordThatAlreadyHasOneFactor() {
        PointRecord pointRecord = getPointRecord();
        pointRecord.setFactors(new HashSet<>(Set.of(Factor.INDOOR_LOCATION)));
        em.persist(pointRecord);
        pointRecord = pointRecordService.findById(pointRecord.getId());

        pointRecordService.addFactor(pointRecord.getId(), Factor.FACIAL_RECOGNITION);
        pointRecord = pointRecordService.findById(pointRecord.getId());
        Set<Factor> actualFactorSet = pointRecord.getFactors();

        assertThat(actualFactorSet, containsInAnyOrder(Factor.INDOOR_LOCATION, Factor.FACIAL_RECOGNITION));
    }

    @Test
    @TestTransaction
    @DisplayName("Deve remover um fator de um registro de ponto")
    void shouldRemoveFactorFromAnPointRecord() {
        PointRecord pointRecord = getPointRecord();
        pointRecord.setFactors(new HashSet<>(Set.of(Factor.FACIAL_RECOGNITION)));
        em.persist(pointRecord);
        pointRecord = pointRecordService.findById(pointRecord.getId());

        pointRecordService.removeFactor(pointRecord.getId(), Factor.FACIAL_RECOGNITION);
        pointRecord = pointRecordService.findById(pointRecord.getId());
        Set<Factor> actualFactorSet = pointRecord.getFactors();

        assertIterableEquals(Set.of(), actualFactorSet);
    }

    @Test
    @TestTransaction
    @DisplayName("Deve remover um fator de um registro de ponto que já possui outro fator")
    void shouldRemoveFactorFromAnPointRecordThatAlreadyHasAnotherFactor() {
        PointRecord pointRecord = getPointRecord();
        pointRecord.setFactors(new HashSet<>(Set.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION)));
        em.persist(pointRecord);
        pointRecord = pointRecordService.findById(pointRecord.getId());

        pointRecordService.removeFactor(pointRecord.getId(), Factor.FACIAL_RECOGNITION);
        pointRecord = pointRecordService.findById(pointRecord.getId());
        Set<Factor> actualFactorSet = pointRecord.getFactors();

        assertEquals(Set.of(Factor.INDOOR_LOCATION), actualFactorSet);
    }

    @Test
    @TestTransaction
    @DisplayName("Não deve fazer nada ao remover um fator de um registro de ponto que não possui fatores")
    void shouldDoNothingWhenRemovingFactorFromAnPointRecordWithNoFactors() {
        PointRecord pointRecord = getPointRecord();
        pointRecord.setFactors(new HashSet<>());
        em.persist(pointRecord);
        pointRecord = pointRecordService.findById(pointRecord.getId());

        pointRecordService.removeFactor(pointRecord.getId(), Factor.FACIAL_RECOGNITION);
        pointRecord = pointRecordService.findById(pointRecord.getId());
        Set<Factor> actualFactorSet = pointRecord.getFactors();

        assertIterableEquals(Set.of(), actualFactorSet);
    }
}