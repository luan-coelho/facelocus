package br.unitins.facelocus.commons.pagination;

import jakarta.ws.rs.FormParam;

import java.io.InputStream;

public class MultipartData {

    @FormParam("file")
    public InputStream inputStream;
}