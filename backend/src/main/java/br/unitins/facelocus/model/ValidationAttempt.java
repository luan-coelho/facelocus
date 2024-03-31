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
public class ValidationAttempt {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @ManyToOne
    private FacePhoto facePhoto;

    private Double distanceInMeters;

    private LocalDateTime facialRecognitionValidationTime;

    private LocalDateTime indoorLocationValidationTime;

    private boolean validatedSuccessfully;

    @ManyToOne
    private AttendanceRecord attendanceRecord;
}