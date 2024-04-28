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
public class UserAttendance {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @ManyToOne
    private User user;

    @OneToMany(mappedBy = "userAttendance", cascade = CascadeType.ALL)
    private List<AttendanceRecord> attendanceRecords = new ArrayList<>();

    @ManyToOne
    private PointRecord pointRecord;

    @Transient
    private boolean validatedFaceRecognition;

    @Transient
    private boolean validatedLocation;
}