package br.unitins.facelocus.dto;

import java.util.Set;

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
    private Long expire_in;
    private Long userId;
    private Set<String> groups;
    private String refresh_token;
}
