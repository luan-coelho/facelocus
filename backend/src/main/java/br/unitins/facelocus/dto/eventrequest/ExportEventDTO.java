package br.unitins.facelocus.dto.eventrequest;

import br.unitins.facelocus.dto.event.LocationDTO;

import java.util.List;

public record ExportEventDTO(Long id,
                             String description,
                             List<LocationDTO> locations,
                             UserResponseExportDTO administrator,
                             List<UserResponseExportDTO> users,
                             List<PointRecordResponseExportDTO> pointRecords,
                             boolean allowTicketRequests) {
}

