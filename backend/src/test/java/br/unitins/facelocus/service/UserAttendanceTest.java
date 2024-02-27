package br.unitins.facelocus.service;

import br.unitins.facelocus.model.PointRecord;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.model.UserAttendance;
import io.quarkus.test.TestTransaction;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@QuarkusTest
class UserAttendanceTest extends BaseTest {

    User user3;
    User user4;
    User user5;

    @Inject
    UserAttendanceService userAttendanceService;

    @Inject
    PointRecordService pointRecordService;

    @BeforeEach
    public void setup() {
        user1 = getUser();
        user2 = getUser();
        user3 = getUser();
        user4 = getUser();
        user5 = getUser();
        event1 = getEvent();
        event2 = getEvent();
        today = LocalDate.now();
        now = LocalDateTime.now();
    }

    @Test
    @TestTransaction
    @DisplayName("Deve retornar uma presença de usuário para ser validada")
    void shouldReturnPointsForUserValidation() {
        PointRecord pointRecord = getPointRecord();
        pointRecord = pointRecordService.create(pointRecord);
        UserAttendance userAttendance = pointRecord.getUsersAttendances().get(0);
        User user = userAttendance.getUser();

        userAttendance = userAttendanceService.findByPointRecordAndUser(pointRecord.getId(), user.getId());

        assertNotNull(userAttendance);
    }
}