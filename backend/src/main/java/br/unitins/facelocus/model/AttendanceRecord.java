package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class AttendanceRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @OneToMany(mappedBy = "attendanceRecord", cascade = CascadeType.ALL)
    private List<ValidationAttempt> validationAttempts = new ArrayList<>();

    @Transient
    private AttendanceRecordStatus status;

    @ManyToOne
    private Point point;
}