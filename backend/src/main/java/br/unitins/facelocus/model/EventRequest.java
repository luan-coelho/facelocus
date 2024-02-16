package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class EventRequest extends DefaultEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    private String code;

    @ManyToOne
    private Event event;

    private EventRequestStatus status = EventRequestStatus.PENDING;

    private EventRequestType requestType = EventRequestType.INVITATION;

    @ManyToOne
    private User initiatorUser; // Usuário que inicia o convite ou solicitação

    @ManyToOne
    private User targetUser; // Usuário que recebe o convite ou a solicitação
}
