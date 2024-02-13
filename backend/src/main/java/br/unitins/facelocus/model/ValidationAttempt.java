package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

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
    private UserFacePhoto userFacePhoto;

    private Double distanceInMeters;

    private LocalDateTime facialRecognitionValidationTime;

    private LocalDateTime indoorLocationValidationTime;

    private boolean validatedSuccessfully;

    @ManyToOne
    private AttendanceRecord attendanceRecord;
}