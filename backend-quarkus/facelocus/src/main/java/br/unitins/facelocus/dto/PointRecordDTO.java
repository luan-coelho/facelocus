package br.unitins.facelocus.dto;

import br.unitins.facelocus.model.Factor;

import java.time.LocalDate;
import java.util.List;

public record PointRecordDTO(Long id,
                             EventDTO event,
                             LocalDate date,
                             LocationDTO locationDTO,
                             List<PointDTO> points,
                             List<Factor> factors,
                             double allowableRadiusInMeters) {
}
