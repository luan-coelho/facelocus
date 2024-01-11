package br.unitins.facelocus.resource;

import br.unitins.facelocus.dto.JwtDTO;
import br.unitins.facelocus.dto.LoginRequestDTO;
import br.unitins.facelocus.dto.UserDTO;
import br.unitins.facelocus.dto.UserResponseDTO;
import br.unitins.facelocus.mapper.UserMapper;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.service.OAuthAuthenticationService;
import br.unitins.facelocus.service.UserService;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
@Path("/auth")
public class AuthResource {

    @Inject
    UserService userService;

    @Inject
    UserMapper userMapper;

    @Inject
    OAuthAuthenticationService authAuthenticationService;

    @Path("/login")
    @POST
    @PermitAll
    public JwtDTO login(@Valid LoginRequestDTO loginRequestDTO) {
        return authAuthenticationService.checkCredentials(loginRequestDTO);
    }

    @Path("/register")
    @POST
    @PermitAll
    public Response register(@Valid UserDTO userDTO) throws InterruptedException {
        Thread.sleep(3000);
        User user = userMapper.toEntity(userDTO);
        User registeredUser = userService.create(user);
        UserResponseDTO dto = userMapper.toResource(registeredUser);
        return Response.ok(dto).build();
    }
}
