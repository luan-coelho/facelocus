package br.unitins.facelocus.config;

import jakarta.enterprise.context.ApplicationScoped;
import org.eclipse.microprofile.config.inject.ConfigProperty;

@ApplicationScoped
public class FaceRecognitionConfig {

    @ConfigProperty(name = "face-recognition.main-service")
    String mainService;

    public FaceRecognitionServiceType getFaceRecognitionServiceType() {
        return FaceRecognitionServiceType.fromString(mainService);
    }

}
