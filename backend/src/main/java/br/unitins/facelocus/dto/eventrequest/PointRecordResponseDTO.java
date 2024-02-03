package br.unitins.facelocus.dto.eventrequest;

import br.unitins.facelocus.dto.LocationDTO;
import br.unitins.facelocus.dto.PointDTO;
import br.unitins.facelocus.model.Factor;

import java.time.LocalDate;
import java.util.List;

public record PointRecordResponseDTO(Long id,
                                     EventWithoutRelationshipsDTO event,
                                     LocalDate date,
                                     LocationDTO location,
                                     List<PointDTO> points,
                                     List<Factor> factors,
                                     Double allowableRadiusInMeters,
                                     boolean inProgress) {
}
