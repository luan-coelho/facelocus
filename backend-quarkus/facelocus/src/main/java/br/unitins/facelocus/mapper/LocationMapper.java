package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.LocationDTO;
import br.unitins.facelocus.model.Location;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface LocationMapper {

    Location toEntity(LocationDTO locationDTO);

    LocationDTO toResource(Location location);
}
