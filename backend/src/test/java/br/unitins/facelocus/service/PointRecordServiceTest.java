package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.commons.pagination.Pagination;
import br.unitins.facelocus.dto.eventrequest.PointRecordResponseDTO;
import br.unitins.facelocus.model.*;
import io.quarkus.test.TestTransaction;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;

import static org.junit.jupiter.api.Assertions.*;

@QuarkusTest
class PointRecordServiceTest {

    private User user1;
    private Event event1;
    private Event event2;
    private LocalDate today;
    private LocalDateTime now;

    @Inject
    EntityManager em;

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
        pointRecord.setFactors(List.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
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
        pointRecord.setFactors(List.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
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
        pointRecord.setFactors(List.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
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
        pointRecord.setFactors(List.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
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
    }

    private PointRecord getPointRecord() {
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event1);
        pointRecord.setDate(today);
        pointRecord.setFactors(List.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
        pointRecord.setInProgress(false);
        Point point = new Point(
                null,
                now,
                now.plusMinutes(15),
                false,
                pointRecord);
        pointRecord.setPoints(List.of(point));
        return pointRecord;
    }

    @Test
    @TestTransaction
    @DisplayName("Deve validar um ponto quando o dados forem corretos")
    void validatePointDataWhenCorrect() {
        PointRecord pointRecord = getPointRecord();
        pointRecordService.create(pointRecord);
        Point point = pointRecord.getPoints().getFirst();
        pointRecordService.validatePoint(point.getId());
    }

    @Transactional
    User getUser() {
        User user = new User();
        user.setName("Joao");
        user.setSurname("Silva");
        user.setCpf("01534043020");
        user.setEmail("joao@gmail.com");
        user.setPassword("12345");
        em.persist(user);
        return user;
    }

    @Transactional
    Event getEvent() {
        Event event = new Event();
        event.setDescription("Evento " + new Random().nextInt(1000));
        event.setCode("ABC123");
        event.setAdministrator(user1);
        em.persist(event);
        return event;
    }
}