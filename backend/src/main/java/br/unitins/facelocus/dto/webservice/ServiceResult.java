package br.unitins.facelocus.dto.webservice;

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
public class ServiceResult {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private boolean faceDetected;
    private float executionTime;
    @Enumerated(EnumType.STRING)
    private ServiceType serviceType;
    @Transient
    private String error;

    public enum ServiceType {
        FACE_RECOGNITION,
        DEEPFACE,
        INSIGHTFACE
    }
}
