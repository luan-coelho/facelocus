package br.unitins.facelocus.service.auth;

import br.unitins.facelocus.dto.JwtDTO;
import br.unitins.facelocus.dto.UserResponseDTO;
import br.unitins.facelocus.mapper.UserMapper;
import br.unitins.facelocus.model.User;
import io.smallrye.jwt.build.Jwt;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import java.security.SecureRandom;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.HashSet;
import java.util.Set;

@ApplicationScoped
public class JWTService {

    public static final int DURATION_IN_SECONDS = 15; // 60 minutos x 24 horas = 1 dia

    @Inject
    UserMapper userMapper;

    public JwtDTO generateJwt(User user) {
        /*String zoneId = "America/Sao_Paulo";
        Instant instant = Instant.now().plusMillis(expirationTime);*/
        Set<String> roles = new HashSet<>(); // TODO Implementar roles
        LocalDateTime expireIn = LocalDateTime.now().plusSeconds(DURATION_IN_SECONDS);
        Instant expiresAt = Instant.now().plus(Duration.ofSeconds(DURATION_IN_SECONDS));
        String token = Jwt.issuer("amazon-jwt")
                .subject("amaonz")
                .claim("userId", user.getId())
                .claim("userEmail", user.getEmail())
                .claim("userCpf", user.getCpf())
                .groups(roles)
                .sign();
        String refreshToken = generateRefreshToken();
        UserResponseDTO userDTO = userMapper.toResource(user);
        return new JwtDTO(token, expireIn, roles, refreshToken, userDTO);
    }

    public String generateRefreshToken() {
        SecureRandom secureRandom = new SecureRandom();
        byte[] randomBytes = new byte[32];
        secureRandom.nextBytes(randomBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
    }
}
