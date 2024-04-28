package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@EqualsAndHashCode(of = "id")
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
    private List<FaceRecognitionValidationAttempt> frValidationAttempts = new ArrayList<>();

    @OneToMany(mappedBy = "attendanceRecord", cascade = CascadeType.ALL)
    private List<LocationValidationAttempt> locationValidationAttempts = new ArrayList<>();

    private AttendanceRecordStatus status = AttendanceRecordStatus.PENDING;

    private boolean frValidatedSuccessfully;

    private boolean locationValidatedSuccessfully;

    @ManyToOne
    private Point point;

    private boolean validatedByAdministrator;

    @ManyToOne
    UserAttendance userAttendance;
}