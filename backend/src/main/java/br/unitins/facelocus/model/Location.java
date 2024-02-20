package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.*;

@EqualsAndHashCode(of = "id", callSuper = false)
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class Location {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    private String description;

    private String latitude;

    private String longitude;

    @ManyToOne
    private Event event;
}