package br.unitins.facelocus.service.facerecognition;

import br.unitins.facelocus.dto.webservice.FaceRecognitionServiceResponse;
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
public class DeepFaceWebService implements FaceRecognitionService {

    @ConfigProperty(name = "deep-face.service.url")
    String DEEP_FACE_SERVICE_URL;

    @Override
    @SneakyThrows
    public boolean faceDetected(String photoFacePath, String profilePhotoFacePath) {
        HttpClient client = HttpClient.newHttpClient();
        String url = String.format("%s?photoFacePath=%s&profilePhotoFacePath=%s", DEEP_FACE_SERVICE_URL, photoFacePath, profilePhotoFacePath);
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .build();

        HttpResponse<String> response;
        try {
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (IOException | InterruptedException e) {
            throw new RuntimeException("Falha ao acessar serviço de reconhecimento facial DeepFace");
        }
        ObjectMapper mapper = new ObjectMapper();

        FaceRecognitionServiceResponse result = mapper.readValue(response.body(), FaceRecognitionServiceResponse.class);

        if (response.statusCode() == 400) {
            throw new IllegalArgumentException(result.getError());
        }

        return result.isFaceDetected();
    }
}
