package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.Pageable;
import io.quarkus.test.TestTransaction;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;

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
    @DisplayName("Deve retornar eventos paginados")
    void getPaginatedEvents() {
        Pageable pageable = new Pageable();
        eventService.findAllPaginated(pageable);
//        assertEquals();
    }
}