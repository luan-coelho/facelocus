package br.unitins.facelocus.dto;

import java.time.LocalDateTime;

public record PointDTO(Long id,
                       LocalDateTime initialDate,
                       LocalDateTime finalDate) {
}
