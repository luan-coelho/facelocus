package br.unitins.facelocus.service.facephoto;

import br.unitins.facelocus.commons.MultipartData;
import br.unitins.facelocus.dto.user.UserFacePhotoValidation;
import br.unitins.facelocus.model.FacePhotoLocalDisk;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.service.EventService;
import br.unitins.facelocus.service.ImageFileService;
import br.unitins.facelocus.service.PointRecordService;
import br.unitins.facelocus.service.UserService;
import br.unitins.facelocus.service.facerecognition.FaceRecognitionWebService;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;
import org.apache.commons.io.FilenameUtils;
import org.jboss.resteasy.reactive.multipart.FileUpload;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@ApplicationScoped
public class FacePhotoLocalDiskService implements FacePhotoService {

    @Inject
    UserService userService;

    @Inject
    ImageFileService imageFileService;

    @Inject
    EventService eventService;

    @Inject
    PointRecordService pointRecordService;

    @Inject
    FaceRecognitionWebService faceRecognitionService;

    @Transactional
    @Override
    public void profileUploud(Long userId, MultipartData multipartData) {
        User user = userService.findById(userId);

        String[] subdirectories = {user.getId().toString(), "profile"};
        FacePhotoLocalDisk facePhoto = saveFileAndBuildFacePhoto(multipartData.file, subdirectories);

        if (user.getFacePhoto() == null) {
            user.setFacePhoto(new FacePhotoLocalDisk());
        }

        FacePhotoLocalDisk originalFacePhoto = (FacePhotoLocalDisk) user.getFacePhoto();
        originalFacePhoto.setFileName(multipartData.file.fileName());
        originalFacePhoto.setFilePath(facePhoto.getFilePath());
        originalFacePhoto.setUser(user);

        eventService.unlinkUserFromAll(userId); // Remove o usuário de todos os eventos que ele está vinculado
        pointRecordService.unlinkUserFromAll(userId); // Remove o usuário de todos os registros de ponto que ele está vinculado

        userService.update(user);
    }

    @Override
    public byte[] getFacePhotoByUser(Long userId) {
        User user = userService.findById(userId);

        try {
            FacePhotoLocalDisk facePhoto = (FacePhotoLocalDisk) user.getFacePhoto();
            File file = new File(facePhoto.getFilePath());
            String extension = FilenameUtils.getExtension(file.getAbsolutePath());
            BufferedImage image = ImageIO.read(file);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(image, extension, baos);
            return baos.toByteArray();
        } catch (Exception e) {
            throw new NotFoundException("Arquivo de foto não encontrado");
        }
    }

    public void facePhotoValidation(Long userId, MultipartData multipartData) {
        User user = userService.findById(userId);

        UserFacePhotoValidation validation = generateFacePhotoValidation(user, multipartData);

        if (!validation.isFaceDetected()) {
            throw new IllegalArgumentException("Rosto não identificado");
        }
    }

    public UserFacePhotoValidation generateFacePhotoValidation(User user, MultipartData multipartData) {
        if (user.getFacePhoto() == null) {
            throw new IllegalArgumentException("Sem foto de perfil não há como prosseguir com a validação");
        }

        String[] subdirectories = {user.getId().toString(), UUID.randomUUID().toString()};
        FacePhotoLocalDisk facePhoto = saveFileAndBuildFacePhoto(multipartData.file, subdirectories);
        String profilePhotoFacePath = ((FacePhotoLocalDisk) user.getFacePhoto()).getFilePath();

        boolean facedDetected = faceRecognitionService.faceDetected(facePhoto.getFilePath(), profilePhotoFacePath);

        UserFacePhotoValidation validation = new UserFacePhotoValidation();
        validation.setFacePhoto(facePhoto);
        validation.setFaceDetected(facedDetected);

        return validation;
    }

    public FacePhotoLocalDisk saveFileAndBuildFacePhoto(FileUpload fileUpload, String... subdirectories) {
        try {
            Path filePath = buildFilePath(fileUpload.fileName(), subdirectories);
            Files.copy(fileUpload.uploadedFile().toAbsolutePath(), filePath, StandardCopyOption.REPLACE_EXISTING);
            FacePhotoLocalDisk facePhoto = new FacePhotoLocalDisk();
            facePhoto.setFileName(fileUpload.fileName());
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
