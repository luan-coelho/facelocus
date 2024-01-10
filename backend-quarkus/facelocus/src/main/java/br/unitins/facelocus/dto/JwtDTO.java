package br.unitins.facelocus.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Set;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class JwtDTO {

    private String token;
    private Long expire_in;
    private Set<String> groups;
    private String refresh_token;
    private UserResponseDTO user;
}
