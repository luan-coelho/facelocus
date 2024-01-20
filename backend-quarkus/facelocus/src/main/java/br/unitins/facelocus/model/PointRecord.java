package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

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
    private List<Point> points;
    @ElementCollection
    private List<Factor> factors;
    private double allowableRadiusInMeters;
    private boolean inProgress;
}