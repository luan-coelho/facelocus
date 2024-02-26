package br.unitins.facelocus.dto.auth;

import java.util.Set;

import br.unitins.facelocus.dto.user.UserResponseDTO;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class JwtDTO {

    private String token;
    private Set<String> groups;
    private String refresh_token;
    private UserResponseDTO user;
}
