package br.unitins.facelocus.service.facerecognition;

import br.unitins.facelocus.dto.webservice.ServiceResult;
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
public class FaceRecognitionWebService {

    @ConfigProperty(name = "face-recognition.service.url")
    String FACE_RECOGNITION_SERVICE_URL;

    @SneakyThrows
    public ServiceResult getResult(String facePhoto, String profileFacePhoto) {
        HttpClient client = HttpClient.newHttpClient();
        String url = String.format("%s?face_photo=%s&profile_face_photo=%s",
                FACE_RECOGNITION_SERVICE_URL,
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

        ServiceResult result = mapper.readValue(
                response.body(),
                ServiceResult.class
        );

        if (response.statusCode() == 400) {
            throw new IllegalArgumentException(result.getError());
        }
        return result;
    }
}
