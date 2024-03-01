package br.unitins.facelocus.service;

import br.unitins.facelocus.dto.eventrequest.EventRequestCreateDTO;
import br.unitins.facelocus.model.EventRequest;
import br.unitins.facelocus.model.EventRequestStatus;
import br.unitins.facelocus.model.EventRequestType;
import io.quarkus.test.TestTransaction;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@QuarkusTest
class EventRequestServiceTest extends BaseTest {

    @Inject
    EventRequestService eventRequestService;

    @BeforeEach
    public void setup() {
        user1 = getUser();
        user2 = getUser();
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
}