package br.unitins.facelocus.commons;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.jboss.resteasy.reactive.multipart.FileUpload;

import java.nio.file.Path;

@AllArgsConstructor
@NoArgsConstructor
public class MockFileUpload implements FileUpload {
    public byte[] data;
    public String fileName;
    public String contentType;
    private String formFieldName;
    private String charSet;

    @Override
    public String name() {
        return formFieldName;
    }

    @Override
    public Path filePath() {
        return null;
    }

    @Override
    public String fileName() {
        return fileName;
    }

    @Override
    public String contentType() {
        return contentType;
    }

    @Override
    public String charSet() {
        return charSet.isEmpty() ? null : charSet;
    }

    @Override
    public long size() {
        return data.length;
    }
}