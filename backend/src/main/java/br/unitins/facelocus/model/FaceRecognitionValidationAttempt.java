package br.unitins.facelocus.model;

import br.unitins.facelocus.dto.webservice.ServiceResult;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@SuppressWarnings("CommentedOutCode")
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

    /*@OneToOne(mappedBy = "faceRecognitionValidationAttempt", cascade = CascadeType.ALL)
    private FaceRecognitionAllServices recognitionResult;*/

    /*@OneToOne(cascade = CascadeType.ALL)
    private ServiceResult serviceResult;*/

    @ManyToOne
    private AttendanceRecord attendanceRecord;
}