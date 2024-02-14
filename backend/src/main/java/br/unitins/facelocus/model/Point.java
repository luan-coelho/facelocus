package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class Point {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    private LocalDateTime initialDate;

    private LocalDateTime finalDate;

    @OneToMany(mappedBy = "point", cascade = CascadeType.ALL)
    private List<UserAttendance> usersAttendances = new ArrayList<>();

    @ManyToOne
    private PointRecord pointRecord;
}