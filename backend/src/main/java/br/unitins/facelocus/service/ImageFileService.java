package br.unitins.facelocus.service;

import jakarta.enterprise.context.ApplicationScoped;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@ApplicationScoped
public class ImageFileService {

    static final String USER_HOME = System.getProperty("user.home");
    static final String SEPARATOR = File.separator; // "\" ou "/"
    static final String RESOURCES_DIRECTORY = "Imagens";


    public String buildResourcePathAndCreate(String... subdirectories) throws IOException {
        String outputPath = SEPARATOR.concat(RESOURCES_DIRECTORY);
        for (String subdirectory : subdirectories) {
            outputPath = outputPath.concat(SEPARATOR).concat(subdirectory);
        }
        String pathBuilt = USER_HOME + outputPath;
        Path path = Paths.get(pathBuilt);
        // Cria o diretório caso não exista
        if (!Files.exists(path)) {
            Files.createDirectories(path);
        }
        return pathBuilt;
    }


    public String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }

        int dotIndex = fileName.lastIndexOf(".");

        if (dotIndex > 0 && dotIndex < fileName.length() - 1) {
            return fileName.substring(dotIndex + 1);
        }
        return null;
    }
}
