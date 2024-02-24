package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.MultipartData;
import br.unitins.facelocus.dto.FaceDetectionResult;
import br.unitins.facelocus.dto.UserFacePhotoValidation;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.model.UserFacePhoto;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import lombok.SneakyThrows;
import org.eclipse.microprofile.config.inject.ConfigProperty;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@ApplicationScoped
public class FaceRecognitionService {

    @ConfigProperty(name = "face-recognition.lib.path")
    String FACE_RECOGNITION_PATH;

    @ConfigProperty(name = "face-recognition.service.url")
    String FACE_RECOGNITION_SERVICE_URL;

    @Inject
    UserService userService;

    @Inject
    ImageFileService imageFileService;

    @Inject
    EventService eventService;

    @Inject
    PointRecordService pointRecordService;

    @Transactional
    public void facePhotoProfileUploud(Long userId, MultipartData multipartBody) {
        User user = userService.findById(userId);
        String[] subdirectories = {user.getId().toString(), "profile"};
        String fileName = "profile.".concat(imageFileService.getFileExtension(multipartBody.fileName));
        UserFacePhoto facePhoto = saveFileAndBuildFacePhoto(fileName, multipartBody.inputStream, subdirectories);

        if (user.getFacePhoto() == null) {
            user.setFacePhoto(new UserFacePhoto());
        }

        UserFacePhoto originalFacePhoto = user.getFacePhoto();
        originalFacePhoto.setFileName(multipartBody.fileName);
        originalFacePhoto.setFilePath(facePhoto.getFilePath());
        originalFacePhoto.setUser(user);

        eventService.unlinkUserFromAll(userId); // Remove o usuário de todos os eventos que ele está vinculado
        pointRecordService.unlinkUserFromAll(userId); // Remove o usuário de todos os registros de ponto que ele está vinculado

        userService.update(user);
    }

    public void facePhotoValidation(Long userId, MultipartData multipartBody) {
        User user = userService.findById(userId);

        UserFacePhotoValidation validation = generateFacePhotoValidation(user, multipartBody);

        if (!validation.isFaceDetected()) {
            throw new IllegalArgumentException("Rosto não identificado");
        }
    }

    public UserFacePhotoValidation generateFacePhotoValidation(User user, MultipartData multipartBody) {
        if (user.getFacePhoto() == null) {
            throw new IllegalArgumentException("Sem foto de perfil não há como prosseguir com a validação");
        }

        String[] subdirectories = {user.getId().toString(), UUID.randomUUID().toString()};
        String fileName = String.join("-", user.getId().toString(), "facephoto").concat(".");
        fileName = fileName.concat(imageFileService.getFileExtension(multipartBody.fileName));
        UserFacePhoto facePhoto = saveFileAndBuildFacePhoto(fileName, multipartBody.inputStream, subdirectories);
        String photoFaceDirectory = facePhoto.getFilePath().replace("/".concat(fileName), "");
        String profilePhotoFacePath = user.getFacePhoto().getFilePath();

        boolean facedDetected = faceDetected(facePhoto.getFilePath(), profilePhotoFacePath);

        UserFacePhotoValidation validation = new UserFacePhotoValidation();
        validation.setUserFacePhoto(facePhoto);
        validation.setFaceDetected(facedDetected);

        return validation;
    }

    public UserFacePhoto saveFileAndBuildFacePhoto(String fileName, InputStream file, String... subdirectories) {
        try {
            Path filePath = buildFilePath(fileName, subdirectories);
            Files.copy(file, filePath, StandardCopyOption.REPLACE_EXISTING);
            UserFacePhoto facePhoto = new UserFacePhoto();
            facePhoto.setFileName(fileName);
            facePhoto.setFilePath(filePath.toString());
            return facePhoto;
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private Path buildFilePath(String fileName, String... subdirectories) throws IOException {
        String pathInput = imageFileService.buildResourcePathAndCreate(subdirectories);
        return Paths.get(pathInput, fileName);
    }

    /*private boolean faceDetected(String photoFaceDirectoryPath, String profilePhotoFacePath) {
        String output;
        try {
            output = requestCall(photoFaceDirectoryPath, profilePhotoFacePath);
        } catch (IOException | InterruptedException e) {
            String message = "Falha ao executar a biblioteca face_recognition. Verifique se ela está instalada corretamente";
            throw new RuntimeException(message);
        }
        return !(output.contains("unknown_person") || output.contains("no_persons_found"));
    }*/

    @SneakyThrows
    private boolean faceDetected(String photoFacePath, String profilePhotoFacePath) {
        HttpClient client = HttpClient.newHttpClient();
        String url = String.format("%s?photoFacePath=%s&profilePhotoFacePath=%s", FACE_RECOGNITION_SERVICE_URL, photoFacePath, profilePhotoFacePath);
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
        FaceDetectionResult result = mapper.readValue(response.body(), FaceDetectionResult.class);
        return result.isFaceDetected();
    }

    private String requestCall(String photoFaceDirectoryPath, String profilePhotoFacePath) throws IOException, InterruptedException {
        StringBuilder output = new StringBuilder();
        // É necessário adicionar face_recognition as variáveis de ambiente, caso contrário o java não encontra
        String[] args = {FACE_RECOGNITION_PATH, photoFaceDirectoryPath, profilePhotoFacePath};
        ProcessBuilder processBuilder = new ProcessBuilder(args);
        processBuilder.redirectErrorStream(true);
        Process process = processBuilder.start();

        int exitCode = process.waitFor();

        try (InputStream inputStream = process.getInputStream();
             InputStreamReader inputStreamReader = new InputStreamReader(inputStream, StandardCharsets.UTF_8);
             BufferedReader reader = new BufferedReader(inputStreamReader)) {

            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }
        }

        if (exitCode != 0) {
            throw new IOException("A execução do comando falhou com o código de saída: " + exitCode);
        }

        return output.toString();
    }
}
