package br.unitins.facelocus.service;

import br.unitins.facelocus.model.*;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;
import java.util.Set;

public abstract class BaseTest {

    protected User user1;
    protected User user2;
    protected Event event1;
    protected Event event2;
    protected LocalDate today;
    protected LocalDateTime now;

    @Inject
    EntityManager em;

    @Transactional
    protected User getUser() {
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
    protected Event getEvent() {
        Event event = new Event();
        event.setDescription("Evento " + new Random().nextInt(1000));
        event.setCode("ABC123");
        event.setAdministrator(user1);
        em.persist(event);
        event.setLocations(List.of(new Location(null, "Casa", "23231232", "123232332", event)));
        em.persist(event);
        return event;
    }

    protected PointRecord getPointRecord() {
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event1);
        pointRecord.setDate(today);
        pointRecord.setFactors(Set.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
        pointRecord.setAllowableRadiusInMeters(5d);
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
}
