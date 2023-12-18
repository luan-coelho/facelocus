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
public class AttendanceRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private LocalDateTime dateTime;
    @ManyToOne
    private User user;
    @ManyToOne
    private UserFacePhoto userFacePhoto;
    @ManyToOne
    private Point point;
}