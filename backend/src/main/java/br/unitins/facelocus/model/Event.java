package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@EqualsAndHashCode(of = "id", callSuper = false)
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class Event extends DefaultEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    private String description;

    @OneToMany(mappedBy = "event")
    private List<PointRecord> pointRecords;

    @OneToMany(mappedBy = "event", cascade = CascadeType.ALL)
    private List<Location> locations = new ArrayList<>();

    @ManyToOne
    private User administrator;

    @ManyToMany
    private List<User> users = new ArrayList<>();

    private String code;

    private boolean allowTicketRequests;

    @OneToMany(mappedBy = "event")
    private List<EventRequest> ticketRequests;
}