package br.unitins.facelocus.service.facephoto;

import br.unitins.facelocus.commons.MultipartData;
import br.unitins.facelocus.dto.user.UserFacePhotoValidation;
import br.unitins.facelocus.dto.webservice.ServiceResult;
import br.unitins.facelocus.model.FacePhoto;
import br.unitins.facelocus.model.FacePhotoS3;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.repository.FacePhotoRepository;
import br.unitins.facelocus.service.BaseService;
import br.unitins.facelocus.service.UserService;
import br.unitins.facelocus.service.facerecognition.FaceRecognitionWebService;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.jboss.resteasy.reactive.multipart.FileUpload;
import software.amazon.awssdk.core.ResponseBytes;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

@ApplicationScoped
public class FacePhotoS3Service extends BaseService<FacePhoto, FacePhotoRepository> {

    @ConfigProperty(name = "aws.bucket.name")
    String bucketName;

    @Inject
    S3Client s3;

    @Inject
    UserService userService;

    @Inject
    FaceRecognitionWebService faceRecognitionService;

    @Inject
    S3ImageFileService imageFileService;

    @Transactional
    public void profileUploud(Long userId, MultipartData multipartData) {
        User user = userService.findById(userId);

        String folderKey = String.valueOf(userId).concat("/");
        String facePhotoKey = folderKey.concat(multipartData.file.fileName());
        PutObjectRequest objectRequest = buildPutRequest(facePhotoKey, multipartData.file);
        RequestBody requestBody = RequestBody.fromFile(multipartData.file.filePath());
        s3.putObject(objectRequest, requestBody);

        FacePhotoS3 facePhoto = (FacePhotoS3) user.getFacePhoto();
        if (facePhoto == null) {
            facePhoto = new FacePhotoS3();
        }
        facePhoto.setFileName(multipartData.file.fileName());
        facePhoto.setObjectKey(facePhotoKey);
        facePhoto.setUser(user);
        facePhoto.setBucket(bucketName);
        user.setFacePhoto(facePhoto);

        this.repository.getEntityManager().merge(facePhoto);
        userService.update(user);
    }

    public byte[] getFacePhotoByUser(Long userId) {
        User user = userService.findById(userId);
        if (user.getFacePhoto() == null) {
            throw new IllegalArgumentException("Sem foto de perfil");
        }
        FacePhotoS3 facePhoto = (FacePhotoS3) user.getFacePhoto();
        String objectKey = facePhoto.getObjectKey();
        ResponseBytes<GetObjectResponse> objectBytes = s3.getObjectAsBytes(buildGetRequest(objectKey));
        return objectBytes.asByteArray();
    }

    private PutObjectRequest buildPutRequest(String objectKey, FileUpload fileUpload) {
        return PutObjectRequest.builder()
                .bucket(bucketName)
                .key(objectKey)
                .contentType(fileUpload.contentType())
                .build();
    }

    protected GetObjectRequest buildGetRequest(String objectKey) {
        return GetObjectRequest.builder()
                .bucket(bucketName)
                .key(objectKey)
                .build();
    }

    @SuppressWarnings("unused")
    public void createFolder(String folderName) {
        String folderKey = folderName.endsWith("/") ? folderName : folderName + "/";
        s3.putObject(PutObjectRequest.builder()
                        .bucket(bucketName)
                        .key(folderKey)
                        .build(),
                RequestBody.empty());
    }

    @Transactional
    public UserFacePhotoValidation generateFacePhotoValidation(User user, MultipartData multipartData) {
        FacePhoto profileFacePhoto = user.getFacePhoto();

        if (profileFacePhoto == null) {
            throw new IllegalArgumentException("Sem foto de perfil não há como prosseguir com a validação");
        }

        String[] subdirectories = {user.getId().toString(), UUID.randomUUID().toString()};
        FacePhotoS3 facePhoto = saveFileAndBuildFacePhoto(multipartData.file, subdirectories);
        facePhoto.setUser(user);
        this.repository.persist(facePhoto);

        ServiceResult result = faceRecognitionService.getResult(
                facePhoto.getObjectKey(),
                ((FacePhotoS3) profileFacePhoto).getObjectKey()
        );
        boolean faceDetected = result.isFaceDetected();
        UserFacePhotoValidation validation = new UserFacePhotoValidation();
        validation.setFacePhoto(facePhoto);
        validation.setFaceDetected(faceDetected);
        validation.setRecognitionResult(result);

        return validation;
    }

    public FacePhotoS3 saveFileAndBuildFacePhoto(FileUpload fileUpload, String... subdirectories) {
        String path = imageFileService.buildPath(subdirectories);
        String folderKey = String.valueOf(path).concat("/");
        String facePhotoKey = folderKey.concat(fileUpload.fileName());
        PutObjectRequest objectRequest = buildPutRequest(facePhotoKey, fileUpload);
        RequestBody requestBody = RequestBody.fromFile(fileUpload.filePath());
        s3.putObject(objectRequest, requestBody);

        FacePhotoS3 facePhoto = new FacePhotoS3();
        facePhoto.setFileName(fileUpload.fileName());
        facePhoto.setObjectKey(facePhotoKey);
        facePhoto.setBucket(bucketName);

        return facePhoto;
    }

    @SuppressWarnings("unused")
    public Path downloadPhotoAndReturnPath(String objectKey) {
        try {
            ResponseBytes<GetObjectResponse> objectBytes = s3.getObjectAsBytes(buildGetRequest(objectKey));
            byte[] fileBytes = objectBytes.asByteArray();
            String fileExtension = ".jpg";
            String uuid = UUID.randomUUID().toString();
            Path tempFile = Files.createTempFile("s3image-" + uuid, fileExtension);
            Files.write(tempFile, fileBytes);

            // tempFile.toFile().delete();
            return tempFile;
        } catch (IOException e) {
            throw new RuntimeException("Falha ao recuperar a imagem de perfil");
        }
    }

}
