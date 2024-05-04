package br.unitins.facelocus.service.facerecognition;

import br.unitins.facelocus.dto.webservice.AllServices;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.enterprise.context.ApplicationScoped;
import lombok.SneakyThrows;
import org.eclipse.microprofile.config.inject.ConfigProperty;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@ApplicationScoped
public class FaceRecognitionAllWebService implements FaceRecognitionService {

    @ConfigProperty(name = "face-recognition.all-services.url")
    String FACE_RECOGNITION_ALL_SERVICES_URL;

    @Override
    @SneakyThrows
    public boolean faceDetected(String facePhoto, String profileFacePhoto) {
        HttpClient client = HttpClient.newHttpClient();
        String url = String.format("%s?face_photo=%s&profile_face_photo=%s",
                FACE_RECOGNITION_ALL_SERVICES_URL,
                facePhoto,
                profileFacePhoto);
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .build();

        HttpResponse<String> response;
        try {
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (IOException | InterruptedException e) {
            throw new RuntimeException("Falha ao acessar serviço de reconhecimento facial");
        }
        ObjectMapper mapper = new ObjectMapper();

        AllServices results = mapper.readValue(
                response.body(),
                AllServices.class
        );

        if (response.statusCode() == 400) {
            throw new IllegalArgumentException(results.getError());
        }
        return checkResults(results);
    }

    private boolean checkResults(AllServices result) {
        boolean faceDetected = result.getFaceRecognition().isFaceDetected();
        boolean deepfaceDetected = result.getDeepface().isFaceDetected();
        boolean insightfaceDetected = result.getInsightface().isFaceDetected();

        int count = 0;
        if (faceDetected) {
            count++;
        }

        if (deepfaceDetected) {
            count++;
        }

        if (insightfaceDetected) {
            count++;
        }

        return count >= 2;
    }
}
