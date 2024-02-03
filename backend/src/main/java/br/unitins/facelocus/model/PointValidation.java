package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class PointValidation {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    @ManyToOne
    private Point point;
    @ManyToOne
    private AttendanceRecord attendanceRecord;
    @OneToMany(mappedBy = "pointValidation")
    private List<PointValidationAttempt> validationAttempts;
    private LocalDateTime facialRecognitionValidationTime;
    private LocalDateTime indoorLocationValidationTime;
}