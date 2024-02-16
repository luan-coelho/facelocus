package br.unitins.facelocus.service;

import br.unitins.facelocus.dto.JwtDTO;
import br.unitins.facelocus.dto.LoginRequestDTO;
import br.unitins.facelocus.handle.restresponse.AuthenticationException;
import br.unitins.facelocus.handle.restresponse.UnauthorizedException;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.service.auth.JWTService;
import br.unitins.facelocus.service.auth.PasswordHandlerService;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;

@ApplicationScoped
public class OAuthAuthenticationService {

    @Inject
    UserService userService;

    @Inject
    PasswordHandlerService passwordHandlerService;

    @Inject
    JWTService jwtService;

    @Transactional
    public JwtDTO checkCredentials(LoginRequestDTO loginRequest) throws AuthenticationException {
        User user = userService.findByEmailOrCpf(loginRequest.login())
                .orElseThrow(() -> {
                    String message = "Não existe nenhuma conta associada a este email";
                    return new AuthenticationException(message);
                });

        if (!passwordHandlerService.checkPassword(loginRequest.password(), user.getPassword())) {
            throw new UnauthorizedException("Verifique seu email ou senha");
        }

        JwtDTO jwt = jwtService.generateJwt(user);
        String refreshToken = jwtService.generateRefreshToken();
        jwt.setRefresh_token(refreshToken);
        return jwt;
    }
}
