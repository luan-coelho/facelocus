package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.*;

@EqualsAndHashCode(of = "id", callSuper = false)
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

    @OneToMany(mappedBy = "pointRecord", cascade = CascadeType.ALL)
    private List<UserAttendance> usersAttendances = new ArrayList<>();
}