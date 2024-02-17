package br.unitins.facelocus.service;

import br.unitins.facelocus.model.*;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.Set;

public abstract class BaseTest {

    protected User user1;
    protected User user2;
    protected Event event1;
    protected Event event2;
    protected Location location;
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
        event.setUsers(new ArrayList<>(List.of(user2)));
        event.setLocations(List.of(location));
        em.merge(event);
        return event;
    }

    @Transactional
    protected Location getLocation() {
        return new Location(null, "Minha Casa", "123456", "654321", event1);
    }

    protected PointRecord getPointRecord() {
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event1);
        pointRecord.setDate(today);
        pointRecord.setFactors(Set.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION));
        pointRecord.setLocation(location);
        pointRecord.setAllowableRadiusInMeters(5d);
        pointRecord.setInProgress(false);
        Point point1 = new Point(
                null,
                now,
                now.plusMinutes(10),
                pointRecord);
        Point point2 = new Point(
                null,
                now.plusMinutes(20),
                now.plusMinutes(30),
                pointRecord);
        Point point3 = new Point(
                null,
                now.plusMinutes(40),
                now.plusMinutes(50),
                pointRecord);
        pointRecord.setPoints(List.of(point1, point2, point3));
        return pointRecord;
    }
}
