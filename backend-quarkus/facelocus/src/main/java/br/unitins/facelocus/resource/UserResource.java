package br.unitins.facelocus.resource;

import br.unitins.facelocus.dto.ChangePasswordDTO;
import br.unitins.facelocus.service.UserService;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.PATCH;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;
import org.jboss.resteasy.reactive.RestQuery;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
@Path("/user")
public class UserResource {

    @Inject
    UserService userService;

    @Path("/change-password")
    @PATCH
    public Response changePassword(@RestQuery("user") Long userId, @Valid ChangePasswordDTO changePasswordDTO) {
        userService.changePassword(userId, changePasswordDTO);
        return Response.ok().build();
    }

}
