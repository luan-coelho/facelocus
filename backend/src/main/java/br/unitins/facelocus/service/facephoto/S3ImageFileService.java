package br.unitins.facelocus.service.facephoto;

import jakarta.enterprise.context.ApplicationScoped;
import org.eclipse.microprofile.config.inject.ConfigProperty;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@ApplicationScoped
public class S3ImageFileService {

    static final String SEPARATOR = File.separator; // "\" ou "/"

    public String buildPath(String[] subdirectories) {
        String outputPath = "";

        for (String subdirectory : subdirectories) {
            outputPath = outputPath.concat(SEPARATOR).concat(subdirectory);
        }

        return outputPath.replaceFirst("/", "");
    }
}
