package br.unitins.facelocus.service.facephoto;

import br.unitins.facelocus.commons.MultipartData;
import br.unitins.facelocus.model.FacePhoto;
import br.unitins.facelocus.model.FacePhotoS3;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.repository.FacePhotoRepository;
import br.unitins.facelocus.service.BaseService;
import br.unitins.facelocus.service.UserService;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import software.amazon.awssdk.core.ResponseBytes;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.*;

@ApplicationScoped
public class FacePhotoS3Service extends BaseService<FacePhoto, FacePhotoRepository> implements FacePhotoService {

    @ConfigProperty(name = "bucket.name")
    String bucketName;

    @Inject
    S3Client s3;

    @Inject
    UserService userService;

    @Transactional
    @Override
    public void profileUploud(Long userId, MultipartData multipartData) {
        User user = userService.findById(userId);

        String folderKey = String.valueOf(userId).concat("/");

        if (!exitsObject(folderKey)) {
            createFolder(folderKey);
            if (exitsObject(folderKey)) {
                throw new RuntimeException("Falha ao criar pasta em bucket AWS S3");
            }
        }
        String facePhotoKey = folderKey.concat(multipartData.file.fileName());
        PutObjectRequest objectRequest = buildPutRequest(facePhotoKey, multipartData);
        RequestBody requestBody = RequestBody.fromFile(multipartData.file.filePath());
        s3.putObject(objectRequest, requestBody);

        FacePhotoS3 facePhoto = (FacePhotoS3) user.getFacePhoto();
        facePhoto.setFileName(multipartData.file.fileName());
        facePhoto.setObjectKey(facePhotoKey);
        facePhoto.setUser(user);
        facePhoto.setBucket(bucketName);

        this.repository.getEntityManager().merge(facePhoto);
    }

    @Override
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

    @Override
    public void facePhotoValidation(Long userId, MultipartData multipartBody) {

    }

    public boolean exitsObject(String objectKey) {
        try {
            s3.headObject(HeadObjectRequest.builder()
                    .bucket(bucketName)
                    .key(objectKey)
                    .build());
            return true;
        } catch (S3Exception e) {
            if (e.awsErrorDetails().errorCode().equals("NoSuchKey")) {
                return false;
            }
            throw e;
        }
    }

    private PutObjectRequest buildPutRequest(MultipartData multipartData) {
        return PutObjectRequest.builder()
                .bucket(bucketName)
                .key(multipartData.file.fileName())
                .contentType(multipartData.file.contentType())
                .build();
    }

    private PutObjectRequest buildPutRequest(String objectKey, MultipartData multipartData) {
        return PutObjectRequest.builder()
                .bucket(bucketName)
                .key(objectKey)
                .contentType(multipartData.file.contentType())
                .build();
    }

    protected GetObjectRequest buildGetRequest(String objectKey) {
        return GetObjectRequest.builder()
                .bucket(bucketName)
                .key(objectKey)
                .build();
    }

    public PutObjectResponse createFolder(String folderName) {
        String folderKey = folderName.endsWith("/") ? folderName : folderName + "/";
        return s3.putObject(PutObjectRequest.builder()
                        .bucket(bucketName)
                        .key(folderKey)
                        .build(),
                RequestBody.empty());
    }
}
