package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class PointRecord {

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

    @OneToMany(mappedBy = "pointRecord", cascade = CascadeType.ALL)
    private List<UserAttendance> usersAttendances = new ArrayList<>();
}