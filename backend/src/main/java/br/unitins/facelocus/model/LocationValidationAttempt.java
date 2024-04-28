package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@EqualsAndHashCode(of = "id", callSuper = false)
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class LocationValidationAttempt {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String latitude;
    private String longitude;
    private Double distanceInMeters;
    private Double allowedDistanceInMeters;
    private LocalDateTime dateTime;
    private boolean validated;

    @ManyToOne
    private AttendanceRecord attendanceRecord;
}