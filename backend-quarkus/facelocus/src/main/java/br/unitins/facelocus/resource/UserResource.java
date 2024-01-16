package br.unitins.facelocus.resource;

import br.unitins.facelocus.dto.ChangePasswordDTO;
import br.unitins.facelocus.dto.UserResponseDTO;
import br.unitins.facelocus.mapper.UserMapper;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.service.UserService;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.PATCH;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.core.Response;
import org.jboss.resteasy.reactive.RestQuery;

import java.util.List;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
@Authenticated
@Path("/user")
public class UserResource {

    @Inject
    UserService userService;

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
    public Response findAllByNameOrCpf(@RestQuery("identifier") String identifier) {
        List<UserResponseDTO> dtos = userService.findAllByNameOrCpf(identifier)
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
}
