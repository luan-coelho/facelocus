package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.commons.pagination.Pagination;
import br.unitins.facelocus.dto.eventrequest.EventDTO;
import br.unitins.facelocus.model.Event;
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
class EventServiceTest extends BaseTest {

    @Inject
    EventService eventService;

    @BeforeEach
    public void setup() {
        user1 = getUser();
        user2 = getUser();
        user3 = getUser();
        event1 = getEvent();
        event2 = getEvent();
        event3 = getEvent();
        today = LocalDate.now();
        now = LocalDateTime.now();
    }

    @Test
    @TestTransaction
    @DisplayName("Deve criar um evento corretamente")
    void DeveCriarUmEventoCorretamente() {
        Event event = new Event();
        event.setDescription("ALG1");

        eventService.create(event);

        assertNotNull(event.getId());
        assertEquals("ALG1", event.getDescription());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve retornar eventos paginados por usuário")
    void shouldReturnPaginatedEventsByUser() {
        Pageable pageable = new Pageable();
        pageable.setSize(1);
        DataPagination<EventDTO> dataPagination = eventService.findAllPaginatedByUser(pageable, user1.getId());
        Pagination pagination = dataPagination.getPagination();
        List<EventDTO> eventList = dataPagination.getData();

        assertEquals(3, pagination.getTotalItems());
        assertEquals(3, pagination.getTotalPages());
        assertEquals(1, eventList.size());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve remover um usuário vinculado")
    void shouldRemoveLinkedUser() {
        event1.setUsers(List.of(user2));
        em.merge(event1);

        eventService.removeUser(event1.getId(), user2.getId());
        event1 = eventService.findById(event1.getId());

        assertTrue(event1.getUsers().isEmpty());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve remover um usuário de todos os eventos que ele está vinculado")
    void shouldRemoveUserFromAllLinkedEvents() {
        event1.setUsers(List.of(user2, user3));
        em.merge(event1);
        event2.setUsers(List.of(user2, user3));
        em.merge(event2);

        eventService.unlinkUserFromAll(user2.getId());

        event1 = eventService.findById(event1.getId());
        event2 = eventService.findById(event2.getId());
        List<Event> events = eventService.findAllByUser(user2.getId());

        assertIterableEquals(List.of(user3), event1.getUsers());
        assertIterableEquals(List.of(user3), event2.getUsers());
        assertTrue(events.isEmpty());
    }
}