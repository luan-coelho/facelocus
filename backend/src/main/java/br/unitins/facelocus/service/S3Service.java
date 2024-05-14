package br.unitins.facelocus.service;

import br.unitins.facelocus.service.facephoto.S3Client;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.apache.commons.io.IOUtils;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Request;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Response;
import software.amazon.awssdk.services.s3.model.S3Object;

import java.io.*;
import java.nio.file.Files;
import java.util.List;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

@ApplicationScoped
public class S3Service {

    @Inject
    S3Client s3Client;

    @ConfigProperty(name = "bucket.name")
    String bucketName;

    public List<String> listAllKeys() {
        software.amazon.awssdk.services.s3.S3Client client = s3Client.s3Client();
        ListObjectsV2Request request = ListObjectsV2Request.builder()
                .bucket(bucketName)
                .build();

        ListObjectsV2Response response;
        List<String> keys;

        do {
            response = client.listObjectsV2(request);
            keys = response.contents().stream()
                    .map(S3Object::key)
                    .collect(Collectors.toList());

            request = ListObjectsV2Request.builder()
                    .bucket(bucketName)
                    .continuationToken(response.nextContinuationToken())
                    .build();
        } while (response.isTruncated());

        return keys;
    }

    public void downloadImagesAndCreateRar(String downloadPath) throws IOException {
        List<String> keys = listAllKeys();

        for (String key : keys) {
            GetObjectRequest getObjectRequest = GetObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();

            InputStream inputStream = s3Client.s3Client().getObject(getObjectRequest);

            // Cria os diretórios necessários
            File file = new File(downloadPath + File.separator + key);
            file.getParentFile().mkdirs();

            // Copia o arquivo para o diretório de destino
            Files.copy(inputStream, file.toPath());
            IOUtils.closeQuietly(inputStream);
        }

        try (ZipOutputStream zipOut = new ZipOutputStream(new FileOutputStream(downloadPath + ".rar"))) {
            for (String key : keys) {
                File fileToZip = new File(downloadPath + File.separator + key);
                try (FileInputStream fis = new FileInputStream(fileToZip)) {
                    ZipEntry zipEntry = new ZipEntry(key);
                    zipOut.putNextEntry(zipEntry);
                    IOUtils.copy(fis, zipOut);
                }
            }
        }
    }
}
