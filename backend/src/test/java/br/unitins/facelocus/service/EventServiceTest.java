package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.commons.pagination.Pagination;
import br.unitins.facelocus.dto.eventrequest.EventDTO;
import br.unitins.facelocus.model.User;
import io.quarkus.test.TestTransaction;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@QuarkusTest
class EventServiceTest extends BaseTest {

    private User user3;

    @Inject
    EventService eventService;

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
    @DisplayName("Deve retornar eventos paginados por usuário")
    void shouldReturnPaginatedEventsByUser() {
        Pageable pageable = new Pageable();
        pageable.setSize(1);
        DataPagination<EventDTO> dataPagination = eventService.findAllPaginatedByUser(pageable, user1.getId());
        Pagination pagination = dataPagination.getPagination();
        List<EventDTO> eventList = dataPagination.getData();

        assertEquals(2, pagination.getTotalItems());
        assertEquals(2, pagination.getTotalPages());
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
        event2.setUsers(List.of(user2, user3));
        em.merge(event1);
        em.merge(event2);

        eventService.unlinkUserFromAll(user2.getId());

        event1 = eventService.findById(event1.getId());
        event2 = eventService.findById(event2.getId());

        assertIterableEquals(new ArrayList<>(List.of(user3)), event1.getUsers());
        assertIterableEquals(new ArrayList<>(List.of(user3)), event2.getUsers());
    }

    // Banco H2 não suporta a função UNACCENT
    /*@Test
    @TestTransaction
    @DisplayName("Deve retornar eventos paginados por descrição com acentuação")
    void getPaginatedEventsByDescriptionWithAccents() {
        event1.setDescription("Atenção");
        em.merge(event1);

        Pageable pageable = new Pageable();
        DataPagination<EventDTO> dataPagination = eventService.findAllByDescription(pageable, user1.getId(), "Atenção");
        Pagination pagination = dataPagination.getPagination();
        List<EventDTO> eventList = dataPagination.getData();

        assertEquals(1, pagination.getTotalItems());
        assertEquals(1, pagination.getTotalPages());
        assertEquals(1, eventList.size());
    }*/
}