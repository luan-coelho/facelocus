package br.unitins.facelocus.dto;

import br.unitins.facelocus.model.Factor;

import java.time.LocalDate;
import java.util.List;

public record PointRecordDTO(Long id,
                             LocalDate date,
                             EventDTO event,
                             List<PointDTO> points,
                             List<Factor> factors,
                             boolean inProgress) {
}
