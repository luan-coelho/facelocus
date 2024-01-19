package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.MultipartData;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.model.UserFacePhoto;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@ApplicationScoped
public class FaceRecognitionService {

    @Inject
    UserService userService;

    @Inject
    ImageFileService imageFileService;

    @Transactional
    public void facePhotoProfileUploud(Long userId, MultipartData multipartBody) {
        User user = userService.findByIdOptional(userId).orElseThrow(() -> {
            String UserNotFoundMessage = "Usuário não encontrado pelo id";
            return new NotFoundException(UserNotFoundMessage);
        });
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
        userService.update(user);
    }

    @Transactional
    public void facePhotoValidation(Long userId, MultipartData multipartBody) {
        User user = userService.findByIdOptional(userId).orElseThrow(() -> {
            String UserNotFoundMessage = "Usuário não encontrado pelo id";
            return new NotFoundException(UserNotFoundMessage);
        });
        if (user.getFacePhoto() == null) {
            throw new IllegalArgumentException("O usuário ainda não há nenhuma foto de perfil. Realize o uploud.");
        }
        String[] subdirectories = {userId.toString(), UUID.randomUUID().toString()};
        String fileName = String.join("-", userId.toString(), "facephoto").concat(".");
        fileName = fileName.concat(imageFileService.getFileExtension(multipartBody.fileName));
        UserFacePhoto facePhoto = saveFileAndBuildFacePhoto(fileName, multipartBody.inputStream, subdirectories);
        String photoFaceDirectory = facePhoto.getFilePath().replace("/".concat(fileName), "");
        String profilePhotoFacePath = user.getFacePhoto().getFilePath();
        boolean faceDetected = faceDetected(photoFaceDirectory, profilePhotoFacePath);
        if (!faceDetected) {
            throw new IllegalArgumentException("Rosto não detectado");
        }
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

    public boolean faceDetected(String photoFaceDirectoryPath, String profilePhotoFacePath) {
        String output;
        try {
            output = requestCall(photoFaceDirectoryPath, profilePhotoFacePath);
        } catch (IOException | InterruptedException e) {
            throw new RuntimeException(e);
        } /*finally {
            try {
                Files.walk(dirImageOutputPath)
                        .sorted(Comparator.reverseOrder())
                        .forEach(path -> {
                            try {
                                Files.delete(path);
                            } catch (IOException ignored) {
                            }
                        });
            } catch (IOException ignored) {
            }
        }*/
        return !output.contains("unknown_person");
    }

    private String requestCall(String photoFaceDirectoryPath, String profilePhotoFacePath) throws IOException, InterruptedException {
        StringBuilder output = new StringBuilder();
        // É necessário adicionar face_recognition as variáveis de ambiente, caso contrário o java não encontra
        String[] args = {"/home/luan/.pyenv/shims/face_recognition", photoFaceDirectoryPath, profilePhotoFacePath};
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
