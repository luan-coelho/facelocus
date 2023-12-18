package br.unitins.facelocus.resource;

import br.unitins.facelocus.dto.UserDTO;
import br.unitins.facelocus.mapper.UserMapper;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.service.UserService;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;

@Path("/auth")
public class AuthResource {

    @Inject
    UserService userService;

    @Inject
    UserMapper userMapper;

    @Path("/register")
    @POST
    public Response register(@Valid UserDTO userDTO) {
        User user = userMapper.toEntity(userDTO);
        User registeredUser = userService.create(user);
        UserDTO dto = userMapper.toResource(registeredUser);
        return Response.ok(dto).build();
    }
}
