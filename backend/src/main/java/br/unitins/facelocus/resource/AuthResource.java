package br.unitins.facelocus.resource;

import br.unitins.facelocus.dto.auth.JwtDTO;
import br.unitins.facelocus.dto.auth.LoginRequestDTO;
import br.unitins.facelocus.dto.user.UserDTO;
import br.unitins.facelocus.dto.user.UserResponseDTO;
import br.unitins.facelocus.mapper.UserMapper;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.service.OAuthAuthenticationService;
import br.unitins.facelocus.service.UserService;
import io.quarkus.security.Authenticated;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;

@SuppressWarnings("QsUndeclaredPathMimeTypesInspection")
@PermitAll
@Path("/auth")
public class AuthResource {

    @Inject
    UserService userService;

    @Inject
    UserMapper userMapper;

    @Inject
    OAuthAuthenticationService authAuthenticationService;

    @Authenticated
    @Path("/check-token")
    @GET
    public Response checkToken() {
        return Response.ok().build();
    }


    @Path("/login")
    @POST
    public Response login(@Valid LoginRequestDTO loginRequestDTO) {
        JwtDTO dto = authAuthenticationService.checkCredentials(loginRequestDTO.login(), loginRequestDTO.password());
        return Response.ok(dto).build();
    }

    @Path("/register")
    @POST
    public Response register(@Valid UserDTO userDTO) {
        User user = userMapper.toEntity(userDTO);
        User registeredUser = userService.create(user);
        UserResponseDTO dto = userMapper.toResource(registeredUser);
        return Response.ok(dto).build();
    }
}
