package br.unitins.facelocus.service;

import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.model.Factor;
import br.unitins.facelocus.model.Point;
import br.unitins.facelocus.model.PointRecord;
import br.unitins.facelocus.repository.EventRepository;
import io.quarkus.test.TestTransaction;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

@QuarkusTest
class PointRecordServiceTest {

    private Event event;
    private LocalDate today;
    private LocalDateTime now;

    @Inject
    PointRecordService pointRecordService;

    @Inject
    EventRepository eventRepository;

    @BeforeEach
    public void setup() {
        event = eventRepository.findFirst();
        today = LocalDate.now();
        now = LocalDateTime.now();
    }

    @Test
    @TestTransaction
    @DisplayName("Deve criar um registro de ponto com sucesso quandos os dados forem válidos")
    void mustCreatePointRecordSuccessfullyWhenDataAreValid() {
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event);
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

        pointRecordService.create(pointRecord);

        assert pointRecord.getId() != null;
        assert pointRecord.getEvent() != null && pointRecord.getEvent().getId() != null;
        assert pointRecord.getDate() != null && pointRecord.getDate().isEqual(today);
        assert pointRecord.getFactors() != null && pointRecord.getFactors().size() == 2;
        assert pointRecord.getPoints() != null && !pointRecord.getPoints().isEmpty();
        assert !pointRecord.isInProgress();
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando a data for anterior ao dia de hoje")
    void throwExceptionIfDateIsBeforeToday() {
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event);
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
        pointRecord.setEvent(event);
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
        pointRecord.setEvent(event);
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
        pointRecord.setEvent(event);
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
        pointRecord.setEvent(event);
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
}