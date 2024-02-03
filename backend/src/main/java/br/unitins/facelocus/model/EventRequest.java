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
public class EventRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String code;
    private LocalDateTime finalDateTime;
    @ManyToOne
    private Event event;
    private EventRequestStatus requestStatus = EventRequestStatus.PENDING;
    private EventRequestType requestType = EventRequestType.INVITATION;
    @ManyToOne
    private User requestOwner;
}
