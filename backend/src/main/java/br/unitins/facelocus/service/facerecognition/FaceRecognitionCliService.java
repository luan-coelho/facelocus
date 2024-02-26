package br.unitins.facelocus.service.facerecognition;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Named;
import org.eclipse.microprofile.config.inject.ConfigProperty;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

@Named("face-recognition-cli")
@ApplicationScoped
public class FaceRecognitionCliService implements FaceRecognitionService {

    @ConfigProperty(name = "face-recognition.lib.path")
    String FACE_RECOGNITION_PATH;

    @Override
    public boolean faceDetected(String photoFaceDirectoryPath, String profilePhotoFacePath) {
        String output;
        try {
            output = requestCall(photoFaceDirectoryPath, profilePhotoFacePath);
        } catch (IOException | InterruptedException e) {
            String message = "Falha ao executar a biblioteca face_recognition. Verifique se ela está instalada corretamente";
            throw new RuntimeException(message);
        }
        return !(output.contains("unknown_person") || output.contains("no_persons_found"));
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
