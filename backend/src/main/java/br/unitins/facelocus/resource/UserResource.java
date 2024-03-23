package br.unitins.facelocus.resource;

import br.unitins.facelocus.commons.MultipartData;
import br.unitins.facelocus.dto.user.ChangePasswordDTO;
import br.unitins.facelocus.dto.user.UserResponseDTO;
import br.unitins.facelocus.mapper.UserMapper;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.service.UserService;
import br.unitins.facelocus.service.facephoto.FacePhotoS3Service;
import io.quarkus.security.Authenticated;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.jboss.resteasy.reactive.RestQuery;

import java.util.List;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
//@Authenticated
@PermitAll
@Path("/user")
public class UserResource {

    @Inject
    UserService userService;

    @Inject
    FacePhotoS3Service facePhotoService;

    @Inject
    UserMapper userMapper;

    @GET
    public Response findAllByEvent(@RestQuery("event") Long eventId) {
        List<UserResponseDTO> dtos = userService.findAllByEventId(eventId)
                .stream()
                .map(location -> userMapper.toResource(location))
                .toList();
        return Response.ok(dtos).build();
    }

    @Path("/search")
    @GET
    public Response findAllByNameOrCpf(@RestQuery("user") Long userId, @RestQuery("identifier") String identifier) {
        List<UserResponseDTO> dtos = userService.findAllByNameOrCpf(userId, identifier)
                .stream()
                .map(location -> userMapper.toResource(location))
                .toList();
        return Response.ok(dtos).build();
    }

    @Path("/{id}")
    @GET
    public Response findById(@PathParam("id") Long userId) {
        User user = userService.findById(userId);
        UserResponseDTO dto = userMapper.toResource(user);
        return Response.ok(dto).build();
    }

    @Path("/change-password")
    @PATCH
    public Response changePassword(@RestQuery("user") Long userId, @Valid ChangePasswordDTO changePasswordDTO) {
        userService.changePassword(userId, changePasswordDTO);
        return Response.ok().build();
    }

    @Path("/uploud-face-photo")
    @POST
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    public Response facePhotoProfileUploud(@RestQuery("user") Long userId, @Valid MultipartData multipartBody) {
        facePhotoService.profileUploud(userId, multipartBody);
        return Response.ok().build();
    }

    @Path("/check-face")
    @POST
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    public Response checkFace(@RestQuery("user") Long userId, @Valid MultipartData multipartBody) {
        facePhotoService.facePhotoValidation(userId, multipartBody);
        return Response.ok().build();
    }

    @Path("/face-photo")
    @GET
    @Produces(MediaType.APPLICATION_OCTET_STREAM)
    public Response getUserFacePhoto(@RestQuery("user") Long userId) {
        byte[] facePhotoBytes = facePhotoService.getFacePhotoByUser(userId);
        return Response.ok(facePhotoBytes).build();
    }
}
