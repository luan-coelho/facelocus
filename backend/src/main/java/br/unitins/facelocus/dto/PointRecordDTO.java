package br.unitins.facelocus.dto;

import br.unitins.facelocus.model.Factor;

import java.time.LocalDate;
import java.util.List;
import java.util.Set;

public record PointRecordDTO(Long id,
                             EventDTO event,
                             LocalDate date,
                             LocationDTO locationDTO,
                             List<PointDTO> points,
                             Set<Factor> factors,
                             Double allowableRadiusInMeters) {
}
