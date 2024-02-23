package br.unitins.facelocus.commons;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.ws.rs.FormParam;

import java.io.InputStream;

public class MultipartData {

    @NotNull(message = "Informe o arquivo")
    @FormParam("file")
    public InputStream inputStream;

    @NotBlank(message = "Informe o nome do arquivo")
    @FormParam("fileName")
    public String fileName;
}
