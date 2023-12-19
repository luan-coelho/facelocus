package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.LocationDTO;
import br.unitins.facelocus.model.Location;
import org.mapstruct.*;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
public interface LocationMapper {

    Location toCreateEntity(LocationDTO locationDTO);

    @Mapping(target = "id", ignore = true)
    Location toUpdateEntity(LocationDTO locationDTO);

    LocationDTO toResource(Location location);

    @Mapping(target = "id", ignore = true)
    Location copyProperties(Location location, @MappingTarget Location existingLocation);
}
