package br.unitins.facelocus.resource;

import br.unitins.facelocus.service.S3Service;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

@Path("/s3")
@PermitAll
public class S3Resource {

    @Inject
    S3Service s3Service;

    @GET
    @Path("/download")
    @Produces(MediaType.APPLICATION_OCTET_STREAM)
    public Response downloadAndZip() {
        String downloadPath = "/tmp/s3-images";
        try {
            Files.createDirectories(Paths.get(downloadPath));
            s3Service.downloadImagesAndCreateRar(downloadPath);
            File file = new File(downloadPath + ".rar");
            return Response.ok(file)
                    .header("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"")
                    .build();
        } catch (IOException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("Error downloading files").build();
        }
    }
}

