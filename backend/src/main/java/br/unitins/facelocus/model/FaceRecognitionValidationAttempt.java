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
public class FaceRecognitionValidationAttempt {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @ManyToOne
    private FacePhoto facePhoto;
    private LocalDateTime dateTime;
    private boolean validated;

    @ManyToOne
    private AttendanceRecord attendanceRecord;
}