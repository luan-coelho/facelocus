package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.commons.pagination.Pagination;
import br.unitins.facelocus.dto.EventDTO;
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

@QuarkusTest
class EventServiceTest extends BaseTest {

    @Inject
    EventService eventService;

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
    @DisplayName("Deve retornar eventos paginados por usuário")
    void getPaginatedEvents() {
        Pageable pageable = new Pageable();
        pageable.setSize(1);
        DataPagination<EventDTO> dataPagination = eventService.findAllPaginatedByUser(pageable, user1.getId());
        Pagination pagination = dataPagination.getPagination();
        List<EventDTO> eventList = dataPagination.getData();

        assertEquals(2, pagination.getTotalItems());
        assertEquals(2, pagination.getTotalPages());
        assertEquals(1, eventList.size());
    }
}