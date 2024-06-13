package br.unitins.facelocus.commons;

import jakarta.validation.constraints.NotNull;
import jakarta.ws.rs.FormParam;
import org.jboss.resteasy.reactive.multipart.FileUpload;

public class MultipartData {

    @NotNull(message = "Informe o arquivo")
    @FormParam("file")
    public FileUpload file;

}
