package br.unitins.facelocus.service.facephoto;

import br.unitins.facelocus.commons.MultipartData;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import software.amazon.awssdk.core.ResponseBytes;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectResponse;

import java.io.ByteArrayInputStream;

@ApplicationScoped
public class FacePhotoS3Service implements FacePhotoService {

    @ConfigProperty(name = "bucket.name")
    String bucketName;

    @Inject
    S3Client s3;

    @Transactional
    @Override
    public void profileUploud(Long userId, MultipartData multipartData) {
        PutObjectRequest objectRequest = buildPutRequest(multipartData);
        RequestBody requestBody = RequestBody.fromFile(multipartData.file.filePath());
        PutObjectResponse putResponse = s3.putObject(objectRequest, requestBody);
    }

    @Override
    public ByteArrayInputStream getByteArrayInputStreamByUser(Long userId) {
        return null;
    }

    @Override
    public void facePhotoValidation(Long userId, MultipartData multipartBody) {

    }

    protected PutObjectRequest buildPutRequest(MultipartData multipartData) {
        return PutObjectRequest.builder()
                .bucket(bucketName)
                .key(multipartData.file.fileName())
                .contentType(multipartData.file.contentType())
                .build();
    }

    protected GetObjectRequest buildGetRequest(String objectKey) {
        return GetObjectRequest.builder()
                .bucket(bucketName)
                .key(objectKey)
                .build();
    }
}
