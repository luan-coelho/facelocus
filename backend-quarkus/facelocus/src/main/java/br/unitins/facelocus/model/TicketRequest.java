package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class TicketRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String code;
    private LocalDateTime finalDateTime;
    @ManyToOne
    private Event event;
    private TicketRequestStatus requestStatus = TicketRequestStatus.PENDING;
    @ManyToOne
    private User requester;
    @ManyToOne
    private User requested;
}
