package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.EventDTO;
import br.unitins.facelocus.model.Event;
import org.mapstruct.*;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
public interface EventMapper {

    Event toCreateEntity(EventDTO eventDTO);

    @Mapping(ignore = true, target = "registrationPoints")
    @Mapping(ignore = true, target = "locations")
    @Mapping(ignore = true, target = "administrator")
    @Mapping(ignore = true, target = "code")
    @Mapping(ignore = true, target = "ticketRequests")
    Event copyProperties(EventDTO eventDTO);

    EventDTO toResource(Event event);

    @Mapping(target = "id", ignore = true)
    Event copyProperties(Event event, @MappingTarget Event existingEvent);
}
