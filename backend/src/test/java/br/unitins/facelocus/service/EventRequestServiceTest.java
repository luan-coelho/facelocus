package br.unitins.facelocus.service;

import br.unitins.facelocus.dto.eventrequest.EventRequestCreateDTO;
import br.unitins.facelocus.model.*;
import io.quarkus.test.TestTransaction;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@QuarkusTest
class EventRequestServiceTest extends BaseTest {

    @Inject
    EventRequestService eventRequestService;

    @Inject
    PointRecordService pointRecordService;

    @BeforeEach
    public void setup() {
        user1 = getUser();
        user2 = getUser();
        user3 = getUser();
        event1 = getEvent();
        event2 = getEvent();
        today = LocalDate.now();
        now = LocalDateTime.now();
    }

    @Test
    @TestTransaction
    @DisplayName("Deve criar uma solicitação de ingresso com sucesso quandos os dados forem válidos")
    void shouldCreateAdmissionRequestSuccessfullyWhenDataIsValid() {
        event1.setAdministrator(user2);
        event1.setCode("ZFG123");
        em.merge(event1);

        EventRequestCreateDTO dto = new EventRequestCreateDTO(event1, user1, user2);
        EventRequest ticketRequest = eventRequestService.createTicketRequest(dto);

        assertNotNull(ticketRequest.getId());
        assertEquals(user2.getId(), ticketRequest.getEvent().getAdministrator().getId());
        assertEquals("ZFG123", ticketRequest.getCode());
        assertEquals(event1.getId(), ticketRequest.getEvent().getId());
        assertEquals(EventRequestType.TICKET_REQUEST, ticketRequest.getType());
        assertEquals(EventRequestStatus.PENDING, ticketRequest.getStatus());
        assertEquals(user1.getId(), ticketRequest.getInitiatorUser().getId());
        assertEquals(user2.getId(), ticketRequest.getTargetUser().getId());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve ter criado registros de presença ao aceitar uma solicitação")
    void ShouldHaveCreatedAttendanceRecordsWhenRequestIsAccepted() {
        PointRecord pointRecord = getPointRecord();
        pointRecordService.create(pointRecord);

        event1.setAdministrator(user2);
        event1.setCode("ZFG123");
        event1.setAllowTicketRequests(true);
        em.merge(event1);

        EventRequestCreateDTO dto = new EventRequestCreateDTO(event1, user3, user2);
        EventRequest eventRequest = eventRequestService.createTicketRequest(dto);

        eventRequestService.approve(user2.getId(), eventRequest.getId(), EventRequestType.TICKET_REQUEST);
        eventRequest = eventRequestService.findById(eventRequest.getId());

        List<PointRecord> prs = pointRecordService.findAllByEvent(eventRequest.getEvent().getId());
        boolean userFound = prs
                .stream()
                .flatMap(pr -> pr.getUsersAttendances().stream())
                .anyMatch(ua -> ua.getUser().getId().equals(user3.getId()));

        assertEquals(EventRequestStatus.APPROVED, eventRequest.getStatus());
        assertTrue(userFound);
        assertEquals(user2.getId(), eventRequest.getEvent().getAdministrator().getId());
        assertEquals(2, pointRecord.getUsersAttendances().size());
        assertTrue(pointRecord.getUsersAttendances().get(0).getAttendanceRecords()
                .stream()
                .allMatch(ar -> ar.getStatus() == AttendanceRecordStatus.PENDING));
    }
}