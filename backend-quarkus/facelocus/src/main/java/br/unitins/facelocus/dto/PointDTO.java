package br.unitins.facelocus.dto;

import java.time.LocalTime;

public record PointDTO(Long id,
                       LocalTime initialDate,
                       LocalTime finalDate,
                       boolean validated) {
}
