package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class PointRecord extends DefaultEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    private LocalDate date;

    @ManyToOne
    private Event event;

    @OneToMany(mappedBy = "pointRecord", cascade = CascadeType.ALL)
    private List<Point> points = new ArrayList<>();

    @ElementCollection
    @CollectionTable(name = "factors")
    private Set<Factor> factors = new HashSet<>();

    @ManyToOne
    private Location location;

    private Double allowableRadiusInMeters;

    private boolean inProgress;
}