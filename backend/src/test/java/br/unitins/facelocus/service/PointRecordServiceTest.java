package br.unitins.facelocus.service;

import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.model.Factor;
import br.unitins.facelocus.model.Point;
import br.unitins.facelocus.model.PointRecord;
import br.unitins.facelocus.repository.EventRepository;
import io.quarkus.test.TestTransaction;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@QuarkusTest
class PointRecordServiceTest {

    @Inject
    PointRecordService pointRecordService;

    @Inject
    EventRepository eventRepository;

    @Test
    @TestTransaction
    void testaSeCriacaoDeRegistroDePontoERealizadaComSucesso() {
        Event event = eventRepository.findFirst();
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event);
        LocalDate today = LocalDate.now();
        pointRecord.setDate(today);
        pointRecord.setFactors(List.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
        pointRecord.setInProgress(false);
        Point point = new Point(
                null,
                LocalDateTime.now(),
                LocalDateTime.now().plusMinutes(15),
                false,
                pointRecord);
        pointRecord.setPoints(List.of(point));

        pointRecordService.create(pointRecord);

        assert pointRecord.getId() != null;
        assert pointRecord.getEvent() != null && pointRecord.getEvent().getId() != null;
        assert pointRecord.getDate() != null && pointRecord.getDate().isEqual(today);
        assert pointRecord.getFactors() != null && pointRecord.getFactors().size() == 2;
        assert pointRecord.getPoints() != null && !pointRecord.getPoints().isEmpty();
    }
}