package br.unitins.facelocus.service.auth;

import java.security.SecureRandom;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Base64;
import java.util.HashSet;
import java.util.Set;

import br.unitins.facelocus.dto.auth.JwtDTO;
import br.unitins.facelocus.dto.user.UserResponseDTO;
import br.unitins.facelocus.mapper.UserMapper;
import br.unitins.facelocus.model.User;
import io.smallrye.jwt.build.Jwt;
import io.smallrye.jwt.build.JwtClaimsBuilder;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

@ApplicationScoped
public class JWTService {

    @Inject
    UserMapper userMapper;

    private static final Integer tempoExpiracao = 86400000; //24 horas

    public JwtDTO generateJwt(User user) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime exp = now.plus(Duration.ofDays(30)); // Define a expiração para 1 mês
        Instant instantExp = exp.atZone(ZoneId.of("America/Sao_Paulo")).toInstant();

        Set<String> roles = new HashSet<>();
        JwtClaimsBuilder claimsBuilder = Jwt.claims();
        long currentTimeInSecs = Instant.now().getEpochSecond();

        claimsBuilder.issuer("amazon-jwt");
        claimsBuilder.subject("amazon");
        claimsBuilder.issuedAt(currentTimeInSecs);
        claimsBuilder.expiresAt(instantExp.getEpochSecond()); // Define a expiração no token
        claimsBuilder.groups(roles);

        String token = claimsBuilder.jws().sign();
        String refreshToken = generateRefreshToken();
        UserResponseDTO userDTO = userMapper.toResource(user);

        return new JwtDTO(token, roles, refreshToken, userDTO);
    }

    public String generateRefreshToken() {
        SecureRandom secureRandom = new SecureRandom();
        byte[] randomBytes = new byte[32];
        secureRandom.nextBytes(randomBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
    }

    public static int currentTimeInSecs() {
        long currentTimeMS = System.currentTimeMillis();
        return (int) (currentTimeMS / 1000);
    }
}
