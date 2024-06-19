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
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

@ApplicationScoped
public class S3Service {

    @Inject
    S3Client s3Client;

    @ConfigProperty(name = "aws.bucket.name")
    String bucketName;

    final String AWS_BASE_URL = "http://ec2-18-230-249-227.sa-east-1.compute.amazonaws.com:5000";

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

    public void generateCurlCommandsToFile(List<String> keys) {
        // Obtém o diretório do usuário
        String userHome = System.getProperty("user.home");
        String directoryPath = userHome + "/Facelocus";

        // Cria o diretório se não existir
        try {
            Files.createDirectories(Paths.get(directoryPath));
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }

        // Define o caminho do arquivo
        String filePath = directoryPath + "/curl_commands.txt";

        // Agrupa as chaves por prefixo
        Map<String, List<String>> groupedKeys = groupKeysByPrefix(keys);

        // Escreve os comandos curl no arquivo
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (String prefix : groupedKeys.keySet()) {
                List<String> prefixedKeys = groupedKeys.get(prefix);
                for (String facePhotoKey : prefixedKeys) {
                    for (String profileFacePhotoKey : prefixedKeys) {
                        String url = String.format(
                                "/facerecognition/check-faces?face_photo=%s&profile_face_photo=%s",
                                facePhotoKey,
                                profileFacePhotoKey
                        );
                        String curlCommand = String.format("curl -X GET '%s%s'", AWS_BASE_URL, url);
                        writer.write(curlCommand);
                        writer.newLine();
                        writer.newLine();
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public Map<String, List<String>> groupKeysByPrefix(List<String> keys) {
        return keys.stream()
                .collect(Collectors.groupingBy(key -> key.split("/")[0]));
    }

}
