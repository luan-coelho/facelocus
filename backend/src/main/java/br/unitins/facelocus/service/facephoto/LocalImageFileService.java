package br.unitins.facelocus.service.facephoto;

import jakarta.enterprise.context.ApplicationScoped;
import org.eclipse.microprofile.config.inject.ConfigProperty;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@ApplicationScoped
public class LocalImageFileService {

    @ConfigProperty(name = "files.users.facephoto.basepath")
    String USER_HOME;

    @ConfigProperty(name = "files.users.facephoto.resources")
    String RESOURCES_DIRECTORY;

    static final String SEPARATOR = File.separator; // "\" ou "/"

    public String buildResourcePathAndCreate(String... subdirectories) throws IOException {
        String outputPath = buildPath(subdirectories);

        String pathBuilt = USER_HOME + outputPath;
        Path path = Paths.get(pathBuilt);

        // Cria o diretório caso não exista
        if (!Files.exists(path)) {
            Files.createDirectories(path);
        }

        return pathBuilt;
    }

    public String buildPath(String[] subdirectories) {
        String outputPath = SEPARATOR.concat(RESOURCES_DIRECTORY);

        for (String subdirectory : subdirectories) {
            outputPath = outputPath.concat(SEPARATOR).concat(subdirectory);
        }
        return outputPath;
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
