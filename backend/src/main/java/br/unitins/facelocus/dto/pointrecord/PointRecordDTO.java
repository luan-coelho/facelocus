package br.unitins.facelocus.dto.pointrecord;

import br.unitins.facelocus.dto.eventrequest.EventDTO;
import br.unitins.facelocus.dto.event.LocationDTO;
import br.unitins.facelocus.dto.event.PointDTO;
import br.unitins.facelocus.model.Factor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

public record PointRecordDTO(Long id,
                             EventDTO event,
                             LocalDate date,
                             LocationDTO locationDTO,
                             List<PointDTO> points,
                             Set<Factor> factors,
                             Double allowableRadiusInMeters,
                             LocalDateTime createdAt,
                             LocalDateTime updatedAt) {
}
