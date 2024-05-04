package br.unitins.facelocus.dto.webservice;

import br.unitins.facelocus.model.FaceRecognitionValidationAttempt;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class FaceRecognitionAllServices {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    @OneToOne(mappedBy = "services")
    private ServiceResult faceRecognition;
    @OneToOne(mappedBy = "services")
    private ServiceResult deepface;
    @OneToOne(mappedBy = "services")
    private ServiceResult insightface;
    private String error;

    @OneToOne
    FaceRecognitionValidationAttempt faceRecognitionValidationAttempt;
}