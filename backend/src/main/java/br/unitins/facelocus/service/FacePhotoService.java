package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.MultipartData;
import br.unitins.facelocus.dto.UserFacePhotoValidation;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.model.UserFacePhoto;
import br.unitins.facelocus.service.facerecognition.FaceRecognitionService;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import jakarta.transaction.Transactional;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@ApplicationScoped
public class FacePhotoService {

    @Inject
    UserService userService;

    @Inject
    ImageFileService imageFileService;

    @Inject
    EventService eventService;

    @Inject
    PointRecordService pointRecordService;

    @Named("face-recognition-web")
    @Inject
    FaceRecognitionService faceRecognitionService;

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
        String profilePhotoFacePath = user.getFacePhoto().getFilePath();

        boolean facedDetected = faceRecognitionService.faceDetected(facePhoto.getFilePath(), profilePhotoFacePath);

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
}
